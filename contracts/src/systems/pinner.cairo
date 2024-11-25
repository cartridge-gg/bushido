// Interfaces

#[starknet::interface]
trait IPinner<TContractState> {
    fn pin(self: @TContractState, achievement_id: felt252);
    fn unpin(self: @TContractState, achievement_id: felt252);
}

// Contracts

#[dojo::contract]
mod Pinner {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Component imports

    use achievement::components::pinnable::PinnableComponent;

    // Internal imports

    use arcade::constants::NAMESPACE;

    // Local imports

    use super::IPinner;

    // Components

    component!(path: PinnableComponent, storage: pinnable, event: PinnableEvent);
    impl PinnableInternalImpl = PinnableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        pinnable: PinnableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        PinnableEvent: PinnableComponent::Event,
    }

    // Implementations

    #[abi(embed_v0)]
    impl PinnerImpl of IPinner<ContractState> {
        fn pin(self: @ContractState, achievement_id: felt252) {
            let world: WorldStorage = self.world_storage();
            let caller: felt252 = starknet::get_caller_address().into();
            self.pinnable.pin(world, caller, achievement_id);
        }

        fn unpin(self: @ContractState, achievement_id: felt252) {
            let world: WorldStorage = self.world_storage();
            let caller: felt252 = starknet::get_caller_address().into();
            self.pinnable.unpin(world, caller, achievement_id);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@NAMESPACE())
        }
    }
}
