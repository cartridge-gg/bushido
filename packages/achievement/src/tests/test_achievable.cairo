// Core imports

use core::num::traits::Zero;

// Starknet imports

use starknet::ContractAddress;
use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
use starknet::testing;

// Dojo imports

use dojo::world::world::Event;

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
    let (world, systems, _context) = spawn_game();
    clear_events(world.dispatcher.contract_address);
    let tasks = array![TaskTrait::new(TASK_ID, TOTAL, "Description")].span();
    systems
        .achiever
        .create(TROPHY_ID, HIDDEN, INDEX, POINTS, GROUP, ICON, TITLE, "Description", tasks, "");
    let contract_event = starknet::testing::pop_log::<Event>(world.dispatcher.contract_address)
        .unwrap();
    match contract_event {
        Event::EventEmitted(event) => {
            assert_eq!(*event.keys.at(0), TROPHY_ID);
            assert_eq!(*event.values.at(0), 0);
            assert_eq!(*event.values.at(1), INDEX.into());
            assert_eq!(*event.values.at(2), POINTS.into());
            assert_eq!(*event.values.at(3), GROUP.into());
            assert_eq!(*event.values.at(4), ICON.into());
            assert_eq!(*event.values.at(5), TITLE.into());
            assert_eq!(*event.values.at(6), 0);
            assert_eq!(*event.values.at(7), 'Description');
            assert_eq!(*event.values.at(8), 11);
            assert_eq!(*event.values.at(9), 1);
            assert_eq!(*event.values.at(10), TASK_ID);
            assert_eq!(*event.values.at(11), TOTAL.into());
            assert_eq!(*event.values.at(12), 0);
            assert_eq!(*event.values.at(13), 'Description');
            assert_eq!(*event.values.at(14), 11);
        },
        _ => {},
    }
}
#[test]
fn test_achievable_update() {
    let (world, systems, context) = spawn_game();
    clear_events(world.dispatcher.contract_address);
    systems.achiever.update(context.player_id, TASK_ID, COUNT);
    let contract_event = starknet::testing::pop_log::<Event>(world.dispatcher.contract_address)
        .unwrap();
    match contract_event {
        Event::EventEmitted(event) => {
            assert_eq!(*event.keys.at(0), context.player_id);
            assert_eq!(*event.keys.at(1), TASK_ID);
            assert_eq!(*event.values.at(0), COUNT.into());
            assert_eq!(*event.values.at(1), 0);
        },
        _ => {},
    }
}

