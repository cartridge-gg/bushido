#[starknet::component]
mod FriendableComponent {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use society::store::{Store, StoreTrait};

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
    > of InternalTrait<TContractState> {}
}
