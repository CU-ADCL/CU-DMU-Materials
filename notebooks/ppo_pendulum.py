"""
PPO for Inverted Pendulum using Stable Baselines3

Trains a PPO agent on CartPole-v1 (inverted pendulum balancing task).
"""

from stable_baselines3 import PPO
from stable_baselines3.common.env_util import make_vec_env
from stable_baselines3.common.evaluation import evaluate_policy


def watch_agent(model, title, n_episodes=3):
    """Watch the agent play for a few episodes."""
    import gymnasium as gym
    env = gym.make("CartPole-v1", render_mode="human")

    print(f"\n{title}")
    for ep in range(n_episodes):
        obs, _ = env.reset()
        total_reward = 0
        done = False

        while not done:
            action, _ = model.predict(obs, deterministic=True)
            obs, reward, terminated, truncated, info = env.step(action)
            total_reward += reward
            done = terminated or truncated

        print(f"  Episode {ep + 1}: reward = {total_reward:.0f}")

    env.close()


def main():
    # Create vectorized environment (4 parallel envs for faster training)
    env = make_vec_env("CartPole-v1", n_envs=4)

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
        verbose=1,
    )

    # Show untrained agent
    watch_agent(model, "Untrained agent (random policy):", n_episodes=3)

    # Train the agent
    print("\nTraining PPO on CartPole-v1...")
    model.learn(total_timesteps=50_000)

    # Save the model
    model.save("ppo_cartpole")
    print("Model saved to ppo_cartpole.zip")

    # Evaluate the trained agent
    print("\nEvaluating trained agent...")
    eval_env = make_vec_env("CartPole-v1", n_envs=1)
    mean_reward, std_reward = evaluate_policy(model, eval_env, n_eval_episodes=10)
    print(f"Mean reward: {mean_reward:.2f} +/- {std_reward:.2f}")

    # Show trained agent
    watch_agent(model, "Trained agent:", n_episodes=3)


if __name__ == "__main__":
    main()
