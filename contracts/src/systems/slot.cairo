// Interfaces

#[starknet::interface]
trait ISlot<TContractState> {
    fn deploy(self: @TContractState, service: u8, project: felt252, tier: u8);
    fn remove(self: @TContractState, service: u8, project: felt252);
    fn hire(self: @TContractState, project: felt252, account_id: felt252, role: u8);
    fn fire(self: @TContractState, project: felt252, account_id: felt252);
}

// Contracts

#[dojo::contract]
mod Slot {
    // Dojo imports

    use dojo::world::WorldStorage;

    // External imports

    use provider::components::deployable::DeployableComponent;
    use provider::components::groupable::GroupableComponent;
    use provider::types::service::Service;
    use provider::types::tier::Tier;
    use provider::types::role::Role;

    // Internal imports

    use arcade::constants::NAMESPACE;

    // Local imports

    use super::ISlot;

    // Components

    component!(path: DeployableComponent, storage: deployable, event: DeployableEvent);
    impl DeployableImpl = DeployableComponent::InternalImpl<ContractState>;
    component!(path: GroupableComponent, storage: groupable, event: GroupableEvent);
    impl GroupableImpl = GroupableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        deployable: DeployableComponent::Storage,
        #[substorage(v0)]
        groupable: GroupableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        DeployableEvent: DeployableComponent::Event,
        #[flat]
        GroupableEvent: GroupableComponent::Event,
    }

    // Constructor

    fn dojo_init(self: @ContractState) {
        self.deployable.initialize(self.world_storage());
    }

    // Implementations

    #[abi(embed_v0)]
    impl SlotImpl of ISlot<ContractState> {
        fn deploy(self: @ContractState, service: u8, project: felt252, tier: u8,) {
            let world = self.world_storage();
            let caller: felt252 = starknet::get_caller_address().into();
            self.deployable.deploy(world, caller, service.into(), project, tier.into())
        }

        fn remove(self: @ContractState, service: u8, project: felt252,) {
            let world = self.world_storage();
            let caller: felt252 = starknet::get_caller_address().into();
            self.deployable.remove(world, caller, service.into(), project);
        }

        fn hire(self: @ContractState, project: felt252, account_id: felt252, role: u8) {
            let world = self.world_storage();
            let caller: felt252 = starknet::get_caller_address().into();
            self.groupable.add(world, caller, project, account_id, role.into());
        }

        fn fire(self: @ContractState, project: felt252, account_id: felt252) {
            let world = self.world_storage();
            let caller: felt252 = starknet::get_caller_address().into();
            self.groupable.remove(world, caller, project, account_id);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@NAMESPACE())
        }
    }
}
