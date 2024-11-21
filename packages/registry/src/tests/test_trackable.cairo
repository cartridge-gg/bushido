// Core imports

use core::num::traits::Zero;

// Starknet imports

use starknet::ContractAddress;
use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
use starknet::testing;

// Internal imports

use registry::store::{Store, StoreTrait};
use registry::models::game::{Game, GameTrait};
use registry::models::achievement::{Achievement, AchievementTrait};
use registry::tests::mocks::register::{Register, IRegisterDispatcher, IRegisterDispatcherTrait};
use registry::tests::mocks::tracker::{Tracker, ITrackerDispatcher, ITrackerDispatcherTrait};
use registry::tests::setup::setup::{spawn, Systems, Context, PLAYER, OWNER};

// Constants

const WORLD_ADDRESS: felt252 = 'WORLD';
const NAMEPSACE: felt252 = 'NAMESPACE';
const PROJECT: felt252 = 'PROJECT';

// Helpers

fn register(systems: @Systems) {
    testing::set_contract_address(PLAYER());
    (*systems)
        .register
        .register(
            WORLD_ADDRESS,
            NAMEPSACE,
            PROJECT,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
            Option::None,
        );
}

// Tests

#[test]
fn test_trackable_register_achievement() {
    // [Setup]
    let (world, systems, _context) = spawn();
    register(@systems);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.tracker.register(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.id, identifier);
    assert_eq!(achievement.karma, karma);
    // [Assert] Game
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.karma, karma);
}

#[test]
fn test_trackable_update_achievement() {
    // [Setup]
    let (world, systems, _context) = spawn();
    register(@systems);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.tracker.register(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Update] Achievement
    let new_karma: u16 = 20;
    systems.tracker.update(WORLD_ADDRESS, NAMEPSACE, identifier, new_karma);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.karma, new_karma);
    // [Assert] Game
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.karma, new_karma);
}

#[test]
fn test_trackable_publish_achievement() {
    // [Setup]
    let (world, systems, _context) = spawn();
    register(@systems);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.tracker.register(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Publish] Achievement
    systems.tracker.publish(WORLD_ADDRESS, NAMEPSACE, identifier);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.published, true);
}

#[test]
fn test_trackable_whitelist_achievement() {
    // [Setup]
    let (world, systems, _context) = spawn();
    register(@systems);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.tracker.register(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Whitelist] Achievement
    systems.tracker.publish(WORLD_ADDRESS, NAMEPSACE, identifier);
    testing::set_contract_address(OWNER());
    systems.tracker.whitelist(WORLD_ADDRESS, NAMEPSACE, identifier);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.whitelisted, true);
}
