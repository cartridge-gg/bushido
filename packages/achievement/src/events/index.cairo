/// Events

// Internal imports

use achievement::types::task::Task;

#[derive(Clone, Drop, Serde, Introspect)]
#[dojo::event]
pub struct Trophy {
    #[key]
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
}

#[derive(Copy, Drop, Serde, Introspect)]
#[dojo::event]
pub struct Progress {
    #[key]
    player_id: felt252,
    #[key]
    task_id: felt252,
    count: u32,
    time: u64,
}
