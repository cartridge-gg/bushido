// Core imports

use core::num::traits::Zero;

// Starknet imports

use starknet::ContractAddress;
use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
use starknet::testing;

// Internal imports

use achievement::types::task::{Task, TaskTrait};
use achievement::events::trophy::{Trophy, TrophyTrait};
use achievement::events::progress::{Progress, ProgressTrait};
use achievement::tests::mocks::achiever::{Achiever, IAchieverDispatcher, IAchieverDispatcherTrait};
use achievement::tests::setup::setup::{spawn_game, clear_events, Systems, PLAYER};

// Constants

const TROPHY_ID: felt252 = 'TROPHY';
const TASK_ID: felt252 = 'TASK';
const HIDDEN: bool = false;
const INDEX: u8 = 0;
const POINTS: u16 = 10;
const TOTAL: u32 = 100;
const COUNT: u32 = 1;
const GROUP: felt252 = 'Group';
const ICON: felt252 = 'fa-khanda';
const TITLE: felt252 = 'Title';
// Tests

#[test]
fn test_achievable_create() {
    spawn_game();
    // let (_world, _systems, _context) = spawn_game();
// clear_events(world.dispatcher.contract_address);
// let tasks = array![TaskTrait::new(TASK_ID, TOTAL, "Description")].span();
// systems
//     .achiever
//     .create(TROPHY_ID, HIDDEN, INDEX, POINTS, GROUP, ICON, TITLE, "Description", tasks, "");
// let event = starknet::testing::pop_log::<Trophy>(world.dispatcher.contract_address).unwrap();
// // FIXME: Cannot check keys because they are shifted due to dojo macros
// assert_eq!(event.hidden, HIDDEN);
// assert_eq!(event.index, INDEX);
// assert_eq!(event.points, POINTS);
// assert_eq!(event.group, GROUP);
// assert_eq!(event.title, TITLE);
// assert_eq!(event.description, "Description");
// assert_eq!(event.icon, ICON);
// assert_eq!(event.tasks.len(), 1);
// assert_eq!(event.tasks[0].id, @TASK_ID);
// assert_eq!(event.tasks[0].total, @TOTAL);
// assert_eq!(event.tasks[0].description, @"Description");
}
// #[test]
// fn test_achievable_update() {
//     let (world, systems, context) = spawn_game();
//     clear_events(world.dispatcher.contract_address);
//     systems.achiever.update(context.player_id, TASK_ID, COUNT);
//     let event =
//     starknet::testing::pop_log::<Progress>(world.dispatcher.contract_address).unwrap();
//     // FIXME: Cannot check keys because they are shifted due to dojo macros
//     assert_eq!(event.count, COUNT);
//     assert_eq!(event.time, 0);
// }

