#[starknet::component]
mod AchievableComponent {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::info::{get_caller_address, get_block_timestamp, get_contract_address};

    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use achievement::types::task::Task;
    use achievement::store::{Store, StoreTrait};

    // Errors

    mod errors {}

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn create(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
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
            // [Setup] Store
            let store: Store = StoreTrait::new(world);

            // [Event] Emit achievement creation
            store.create(id, hidden, index, points, group, icon, title, description, tasks, data);
        }

        fn update(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            player_id: felt252,
            task_id: felt252,
            count: u32,
        ) {
            // [Setup] Store
            let store: Store = StoreTrait::new(world);

            // [Event] Emit achievement completion
            let time: u64 = get_block_timestamp();
            store.update(player_id, task_id, count, time);
        }
    }
}
