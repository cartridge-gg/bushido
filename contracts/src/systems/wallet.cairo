// Interfaces

#[starknet::interface]
trait IWallet<TContractState> {}

// Contracts

#[dojo::contract]
mod Wallet {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Component imports

    use controller::components::controllable::ControllableComponent;

    // Internal imports

    use arcade::constants::NAMESPACE;

    // Local imports

    use super::IWallet;

    // Components

    component!(path: ControllableComponent, storage: controllable, event: ControllableEvent);
    impl ControllableInternalImpl = ControllableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        controllable: ControllableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ControllableEvent: ControllableComponent::Event,
    }

    // Implementations

    #[abi(embed_v0)]
    impl WalletImpl of IWallet<ContractState> {}

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@NAMESPACE())
        }
    }
}
