#[starknet::component]
mod ControllableComponent {
    // Starknet imports

    use starknet::info::get_caller_address;

    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use achievement::store::{Store, StoreTrait};
    use achievement::models::game::Game;

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    // Errors

    mod errors {
        const CONTROLLABLE_UNAUTHORIZED_CALLER: felt252 = 'Controllable: unauthorized call';
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn assert_is_owner(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252
        ) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Return] Game owner
            let game = store.get_game(world_address, namespace);
            let caller = get_caller_address();
            assert(game.owner == caller.into(), errors::CONTROLLABLE_UNAUTHORIZED_CALLER);
        }
    }
}
