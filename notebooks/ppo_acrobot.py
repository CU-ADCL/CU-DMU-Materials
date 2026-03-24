"""
PPO for Acrobot using Stable Baselines3

Trains a PPO agent on Acrobot-v1 (double pendulum swing-up task).
"""

from stable_baselines3 import PPO
from stable_baselines3.common.env_util import make_vec_env
from stable_baselines3.common.evaluation import evaluate_policy
from stable_baselines3.common.callbacks import EvalCallback, StopTrainingOnRewardThreshold


def watch_agent(model, env_id, title, n_episodes=3, max_seconds=None):
    """Watch the agent play for a few episodes."""
    import gymnasium as gym
    import time
    env = gym.make(env_id, render_mode="human")

    print(f"\n{title}")
    start_time = time.time()
    for ep in range(n_episodes):
        obs, _ = env.reset()
        total_reward = 0
        done = False

        while not done:
            if max_seconds and (time.time() - start_time) > max_seconds:
                print(f"  (stopped after {max_seconds}s)")
                env.close()
                return

            action, _ = model.predict(obs, deterministic=True)
            obs, reward, terminated, truncated, info = env.step(action)
            total_reward += reward
            done = terminated or truncated

        print(f"  Episode {ep + 1}: reward = {total_reward:.0f}")

    env.close()


def main():
    env_id = "Acrobot-v1"

    # Create vectorized environment (4 parallel envs for faster training)
    env = make_vec_env(env_id, n_envs=4)

    # Initialize PPO agent (untrained)
    model = PPO(
        "MlpPolicy",
        env,
        learning_rate=3e-4,
        n_steps=2048,
        batch_size=64,
        n_epochs=10,
        gamma=0.99,
        gae_lambda=0.95,
        clip_range=0.2,
        ent_coef=0.0,
        verbose=1,
    )

    # Show untrained agent (1 episode, max 10 seconds)
    watch_agent(model, env_id, "Untrained agent (random policy):", n_episodes=1, max_seconds=10)

    # Set up early stopping when reward threshold is reached
    # Acrobot gives -1 per step, so -100 means solving in ~100 steps (good performance)
    eval_env = make_vec_env(env_id, n_envs=1)
    stop_callback = StopTrainingOnRewardThreshold(reward_threshold=-100, verbose=1)
    eval_callback = EvalCallback(
        eval_env,
        callback_on_new_best=stop_callback,
        eval_freq=10000,
        best_model_save_path="./logs/acrobot/",
        verbose=1,
    )

    # Train the agent (stops early if reward threshold reached)
    print(f"\nTraining PPO on {env_id}...")
    model.learn(total_timesteps=500_000, callback=eval_callback)

    # Save the model
    model.save("ppo_acrobot")
    print("Model saved to ppo_acrobot.zip")

    # Evaluate the trained agent
    print("\nEvaluating trained agent...")
    mean_reward, std_reward = evaluate_policy(model, eval_env, n_eval_episodes=10)
    print(f"Mean reward: {mean_reward:.2f} +/- {std_reward:.2f}")

    # Show trained agent
    watch_agent(model, env_id, "Trained agent:", n_episodes=3)


if __name__ == "__main__":
    main()
