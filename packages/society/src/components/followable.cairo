#[starknet::component]
mod FollowableComponent {
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
    > of InternalTrait<TContractState> {
        fn follow(self: @ComponentState<TContractState>, world: WorldStorage, followed: felt252) {
            // [Setup] Datastore
            let mut store = StoreTrait::new(world);

            // [Effect] Follow
            let follower = starknet::get_caller_address().into();
            let time = starknet::get_block_timestamp();
            store.follow(follower, followed, time);
        }

        fn unfollow(self: @ComponentState<TContractState>, world: WorldStorage, followed: felt252) {
            // [Setup] Datastore
            let mut store = StoreTrait::new(world);

            // [Effect] Unfollow
            let follower = starknet::get_caller_address().into();
            store.unfollow(follower, followed);
        }
    }
}
