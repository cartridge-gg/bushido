#[starknet::component]
mod GuildableComponent {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use controller::store::{Store, StoreTrait};
    use controller::models::member::{Member, MemberTrait, MemberAssert};

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
