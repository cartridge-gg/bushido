#[starknet::interface]
trait ITracker<TContractState> {
    fn register(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16,
    );
    fn update(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16,
    );
    fn publish(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn hide(self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252);
    fn whitelist(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn blacklist(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
}

#[dojo::contract]
pub mod Tracker {
    // Starknet imports

    use starknet::{ContractAddress, get_block_timestamp, get_contract_address};

    // Dojo imports

    use dojo::world::WorldStorage;
    use dojo::contract::{IContractDispatcher, IContractDispatcherTrait};

    // Internal imports

    use registry::components::initializable::InitializableComponent;
    use registry::components::trackable::TrackableComponent;

    // Local imports

    use super::ITracker;

    // Components

    component!(path: InitializableComponent, storage: initializable, event: InitializableEvent);
    impl InitializableImpl = InitializableComponent::InternalImpl<ContractState>;
    component!(path: TrackableComponent, storage: trackable, event: TrackableEvent);
    impl TrackableImpl = TrackableComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub initializable: InitializableComponent::Storage,
        #[substorage(v0)]
        pub trackable: TrackableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        InitializableEvent: InitializableComponent::Event,
        #[flat]
        TrackableEvent: TrackableComponent::Event
    }

    fn dojo_init(self: @ContractState, owner: felt252) {
        self.initializable.initialize(self.world_storage(), owner);
    }

    #[abi(embed_v0)]
    impl TrackerImpl of ITracker<ContractState> {
        fn register(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            self
                .trackable
                .register(self.world_storage(), world_address, namespace, identifier, karma);
        }

        fn update(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            self
                .trackable
                .update(self.world_storage(), world_address, namespace, identifier, karma);
        }

        fn publish(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.publish(self.world_storage(), world_address, namespace, identifier);
        }

        fn hide(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.hide(self.world_storage(), world_address, namespace, identifier);
        }

        fn whitelist(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.whitelist(self.world_storage(), world_address, namespace, identifier);
        }

        fn blacklist(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self.trackable.blacklist(self.world_storage(), world_address, namespace, identifier);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@"namespace")
        }
    }
}
