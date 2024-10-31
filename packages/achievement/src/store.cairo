//! Store struct and component management methods.

// Starknet imports

use starknet::SyscallResultTrait;

// Dojo imports

use dojo::world::WorldStorage;
use dojo::model::ModelStorage;
use dojo::event::EventStorage;
// Models imports

use achievement::models::game::Game;
use achievement::models::achievement::Achievement;

// Events imports

use achievement::events::trophy::{Trophy, TrophyTrait};
use achievement::events::progress::{Progress, ProgressTrait};

// Internal imports

use achievement::types::task::{Task, TaskTrait};

// Structs

#[derive(Copy, Drop)]
struct Store {
    world: WorldStorage,
}

// Implementations

#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    #[inline]
    fn get_game(self: Store, world_address: felt252, namespace: felt252) -> Game {
        self.world.read_model((world_address, namespace))
    }

    #[inline]
    fn get_achievement(
        self: Store, world_address: felt252, namespace: felt252, id: felt252
    ) -> Achievement {
        self.world.read_model((world_address, namespace, id))
    }

    #[inline]
    fn set_game(ref self: Store, game: Game) {
        self.world.write_model(@game);
    }

    #[inline]
    fn set_achievement(ref self: Store, achievement: Achievement) {
        self.world.write_model(@achievement);
    }

    #[inline]
    fn create(
        mut self: Store,
        id: felt252,
        hidden: bool,
        index: u8,
        points: u16,
        group: felt252,
        icon: felt252,
        title: felt252,
        description: ByteArray,
        tasks: Span<Task>,
        data: ByteArray,
    ) {
        let event: Trophy = TrophyTrait::new(
            id, hidden, index, points, group, icon, title, description, tasks, data
        );
        self.world.emit_event(@event);
    }

    #[inline]
    fn update(mut self: Store, player_id: felt252, task_id: felt252, count: u32, time: u64,) {
        let event: Progress = ProgressTrait::new(player_id, task_id, count, time);
        self.world.emit_event(@event);
    }
}
