#[starknet::component]
mod InitializableComponent {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use registry::store::{Store, StoreTrait};
    use registry::models::access::AccessTrait;
    use registry::types::role::Role;

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
        fn initialize(self: @ComponentState<TContractState>, world: WorldStorage, owner: felt252) {
            // [Effect] Initialize component
            let mut store = StoreTrait::new(world);
            let access = AccessTrait::new(owner, Role::Owner);
            store.set_access(@access);
        }
    }
}
