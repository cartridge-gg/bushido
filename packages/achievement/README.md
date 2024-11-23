# Achievements

The Cartridge Achievements is a system for games to reward players for completing achievements.

## Key Features

- **Packages**: Games can define achievements thanks to the provided packages.
- **Rewards**: Games can reward players with Cartridge points for completing achievements.
- **Profile**: Players can view their achievements and scores whitout leaving the game.

## Benefits for Game Developers

- **Simplicity**: Easy integration with existing Starknet smart contracts and Dojo.
- **Cost-effectiveness**: Achievements are events based, no additional storage is required.
- **Performance** (coming soon): Plugin attached to Torii to improve the performances of the achievements computation.

## How It Works?

### Creation

The game world describes the achievements and the corresponding tasks to unlock them.
Each achievement is defined by (not exhaustive) a unique `identifier`, a `title`, a `description` and a set of `tasks`.
Each task is defined by an `identifier`, a `total` and a `description`.
The completion of a task is done when enough progression has been made by a player regarding a specific task.
The achievement is completed when all included tasks are completed.

### Progression

The progression of each individual task is done by the game by emitting events associated to a `task` and a `player`.
Each progression provides a `counter` to add to the player progression.
A task completion is the sum of all the progression events emitted for a specific `task` (defined by the `identifier`).

### Integration

The status of the achievement is computed off-chain by the controller, it starts when the controller is initialized on the client.
