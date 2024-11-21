// Interfaces

#[starknet::interface]
trait ISlot<TContractState> {
    fn deploy(self: @TContractState, service: u8, project: felt252, tier: u8);
    fn remove(self: @TContractState, service: u8, project: felt252);
}

// Contracts

#[dojo::contract]
mod Slot {
    // Dojo imports

    use dojo::world::WorldStorage;

    // External imports

    use provider::components::deployable::DeployableComponent;
    use provider::types::service::Service;
    use provider::types::tier::Tier;

    // Internal imports

    use arcade::constants::NAMESPACE;

    // Local imports

    use super::ISlot;

    // Components

    component!(path: DeployableComponent, storage: deployable, event: DeployableEvent);
    impl DeployableImpl = DeployableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        deployable: DeployableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        DeployableEvent: DeployableComponent::Event,
    }

    // Implementations

    #[abi(embed_v0)]
    impl SlotImpl of ISlot<ContractState> {
        fn deploy(self: @ContractState, service: u8, project: felt252, tier: u8,) {
            let world = self.world_storage();
            self.deployable.deploy(world, service.into(), project, tier.into())
        }

        fn remove(self: @ContractState, service: u8, project: felt252,) {
            let world = self.world_storage();
            self.deployable.remove(world, service.into(), project);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@NAMESPACE())
        }
    }
}
