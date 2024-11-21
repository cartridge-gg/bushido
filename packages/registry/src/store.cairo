//! Store struct and component management methods.

// Starknet imports

use starknet::SyscallResultTrait;

// Dojo imports

use dojo::world::WorldStorage;
use dojo::model::ModelStorage;
// Models imports

use registry::models::access::Access;
use registry::models::achievement::Achievement;
use registry::models::game::Game;

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
    fn get_access(self: Store, address: felt252) -> Access {
        self.world.read_model(address)
    }

    #[inline]
    fn get_achievement(
        self: Store, world_address: felt252, namespace: felt252, id: felt252
    ) -> Achievement {
        self.world.read_model((world_address, namespace, id))
    }

    #[inline]
    fn get_game(self: Store, world_address: felt252, namespace: felt252) -> Game {
        self.world.read_model((world_address, namespace))
    }

    #[inline]
    fn set_access(ref self: Store, access: @Access) {
        self.world.write_model(access);
    }

    #[inline]
    fn set_achievement(ref self: Store, achievement: @Achievement) {
        self.world.write_model(achievement);
    }

    #[inline]
    fn set_game(ref self: Store, game: @Game) {
        self.world.write_model(game);
    }

    #[inline]
    fn delete_achievement(ref self: Store, achievement: @Achievement) {
        self.world.erase_model(achievement);
    }

    #[inline]
    fn delete_game(ref self: Store, game: @Game) {
        self.world.erase_model(game);
    }
}
