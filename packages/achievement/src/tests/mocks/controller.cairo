#[starknet::interface]
trait IController<TContractState> {
    fn assert_is_authorized(self: @TContractState) {}
    fn assert_is_owner(self: @TContractState, world_address: felt252, namespace: felt252);
}

#[dojo::contract]
pub mod Controller {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use achievement::components::controllable::ControllableComponent;

    // Local imports

    use super::IController;

    // Components

    component!(path: ControllableComponent, storage: controllable, event: ControllableEvent);
    impl InternalImpl = ControllableComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub controllable: ControllableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ControllableEvent: ControllableComponent::Event
    }

    #[abi(embed_v0)]
    impl ControllerImpl of IController<ContractState> {
        fn assert_is_owner(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.controllable.assert_is_owner(self.world_storage(), world_address, namespace);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@"namespace")
        }
    }
}
