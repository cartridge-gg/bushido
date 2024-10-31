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
use achievement::tests::mocks::registrer::{
    Registrer, IRegistrerDispatcher, IRegistrerDispatcherTrait
};
use achievement::tests::setup::setup::{spawn_game, Systems, Context, PLAYER};

// Constants

const WORLD_ADDRESS: felt252 = 'WORLD';
const NAMEPSACE: felt252 = 'NAMESPACE';

// Helpers

fn register_game(systems: @Systems, context: @Context) {
    let name: ByteArray = "NAME";
    let description: ByteArray = "DESCRIPTION";
    let torii_url: ByteArray = "TORII_URL";
    let image_uri: ByteArray = "IMAGE_URI";
    let owner: felt252 = *context.player_id;
    (*systems)
        .registrer
        .register_game(
            WORLD_ADDRESS,
            NAMEPSACE,
            name.clone(),
            description.clone(),
            torii_url.clone(),
            image_uri.clone(),
            owner
        );
}

// Tests

#[test]
fn test_registrable_register_game() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    let name: ByteArray = "NAME";
    let description: ByteArray = "DESCRIPTION";
    let torii_url: ByteArray = "TORII_URL";
    let image_uri: ByteArray = "IMAGE_URI";
    let owner: felt252 = context.player_id;
    // [Register] Game
    systems
        .registrer
        .register_game(
            WORLD_ADDRESS,
            NAMEPSACE,
            name.clone(),
            description.clone(),
            torii_url.clone(),
            image_uri.clone(),
            owner
        );
    // [Assert] Game
    let store = StoreTrait::new(world);
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.world_address, WORLD_ADDRESS);
    assert_eq!(game.namespace, NAMEPSACE);
    assert_eq!(game.published, false);
    assert_eq!(game.whitelisted, false);
    assert_eq!(game.total_karma, 0);
    assert_eq!(game.name, name);
    assert_eq!(game.description, description);
    assert_eq!(game.torii_url, torii_url);
    assert_eq!(game.image_uri, image_uri);
    assert_eq!(game.owner, owner);
}

#[test]
fn test_registrable_update_game() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    // [Update] Game
    let new_name: ByteArray = "NEW_NAME";
    let new_description: ByteArray = "NEW_DESCRIPTION";
    let new_torii_url: ByteArray = "NEW_TORII_URL";
    let new_image_uri: ByteArray = "NEW_IMAGE_URI";
    systems
        .registrer
        .update_game(
            WORLD_ADDRESS,
            NAMEPSACE,
            new_name.clone(),
            new_description.clone(),
            new_torii_url.clone(),
            new_image_uri.clone()
        );
    // [Assert] Game
    let store = StoreTrait::new(world);
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.name, new_name);
    assert_eq!(game.description, new_description);
    assert_eq!(game.torii_url, new_torii_url);
    assert_eq!(game.image_uri, new_image_uri);
}

#[test]
fn test_registrable_publish_game() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    systems.registrer.publish_game(WORLD_ADDRESS, NAMEPSACE);
    // [Assert] Game
    let store = StoreTrait::new(world);
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.published, true);
}

#[test]
fn test_registrable_whitelist_game() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    systems.registrer.publish_game(WORLD_ADDRESS, NAMEPSACE);
    systems.registrer.whitelist_game(WORLD_ADDRESS, NAMEPSACE);
    // [Assert] Game
    let store = StoreTrait::new(world);
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.whitelisted, true);
}

#[test]
fn test_registrable_register_achievement() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.registrer.register_achievement(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.id, identifier);
    assert_eq!(achievement.karma, karma);
    // [Assert] Game
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.total_karma, karma);
}

#[test]
fn test_registrable_update_achievement() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.registrer.register_achievement(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Update] Achievement
    let new_karma: u16 = 20;
    systems.registrer.update_achievement(WORLD_ADDRESS, NAMEPSACE, identifier, new_karma);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.karma, new_karma);
    // [Assert] Game
    let game = store.get_game(WORLD_ADDRESS, NAMEPSACE);
    assert_eq!(game.total_karma, new_karma);
}

#[test]
fn test_registrable_publish_achievement() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.registrer.register_achievement(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Publish] Achievement
    systems.registrer.publish_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.published, true);
}

#[test]
fn test_registrable_whitelist_achievement() {
    // [Setup]
    let (world, systems, context) = spawn_game();
    register_game(@systems, @context);
    // [Register] Achievement
    let identifier: felt252 = 'IDENTIFIER';
    let karma: u16 = 10;
    systems.registrer.register_achievement(WORLD_ADDRESS, NAMEPSACE, identifier, karma);
    // [Whitelist] Achievement
    systems.registrer.publish_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    systems.registrer.whitelist_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    // [Assert] Achievement
    let store = StoreTrait::new(world);
    let achievement = store.get_achievement(WORLD_ADDRESS, NAMEPSACE, identifier);
    assert_eq!(achievement.whitelisted, true);
}
