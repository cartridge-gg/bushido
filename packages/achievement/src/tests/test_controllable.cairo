// Core imports

use core::num::traits::Zero;

// Starknet imports

use starknet::ContractAddress;
use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
use starknet::testing;

// Internal imports

use achievement::store::{Store, StoreTrait};
use achievement::models::game::{Game, GameTrait};
use achievement::models::achievement::{Achievement, AchievementTrait};
use achievement::tests::mocks::controller::{
    Controller, IControllerDispatcher, IControllerDispatcherTrait
};
use achievement::tests::setup::setup::{spawn_game, Systems, Context, OWNER, PLAYER};

// Constants

const WORLD_ADDRESS: felt252 = 'WORLD';
const NAMEPSACE: felt252 = 'NAMESPACE';

// Tests

#[test]
fn test_controllable_assert_is_owner() {
    // [Setup]
    let (world, systems, _context) = spawn_game();
    let mut store = StoreTrait::new(world);
    let game = GameTrait::new(
        WORLD_ADDRESS, NAMEPSACE, "NAME", "DESCRIPTION", "TORII_URL", "IMAGE_URI", OWNER().into()
    );
    store.set_game(game);
    // [Assert]
    systems.controller.assert_is_owner(WORLD_ADDRESS, NAMEPSACE);
}

#[test]
#[should_panic(expected: ('Controllable: unauthorized call', 'ENTRYPOINT_FAILED'))]
fn test_controllable_assert_is_owner_revert() {
    // [Setup]
    let (world, systems, _context) = spawn_game();
    let mut store = StoreTrait::new(world);
    let game = GameTrait::new(
        WORLD_ADDRESS, NAMEPSACE, "NAME", "DESCRIPTION", "TORII_URL", "IMAGE_URI", OWNER().into()
    );
    store.set_game(game);
    // [Assert]
    testing::set_contract_address(PLAYER());
    systems.controller.assert_is_owner(WORLD_ADDRESS, NAMEPSACE);
}
