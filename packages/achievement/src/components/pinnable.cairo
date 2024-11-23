#[starknet::component]
mod PinnableComponent {
    // Core imports

    use core::debug::PrintTrait;

    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

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
        fn pin(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            player_id: felt252,
            achievement_id: felt252,
        ) {
            // [Setup] Store
            let store: Store = StoreTrait::new(world);

            // [Event] Emit achievement creation
            let time = starknet::get_block_timestamp();
            store.pin(player_id, achievement_id, time);
        }

        fn unpin(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            player_id: felt252,
            achievement_id: felt252,
        ) {
            let store: Store = StoreTrait::new(world);
            store.unpin(player_id, achievement_id);
        }
    }
}
