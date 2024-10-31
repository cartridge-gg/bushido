#[starknet::interface]
trait IRegistrer<TContractState> {
    fn register_game(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        name: ByteArray,
        description: ByteArray,
        torii_url: ByteArray,
        image_uri: ByteArray,
        owner: felt252,
    );
    fn update_game(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        name: ByteArray,
        description: ByteArray,
        torii_url: ByteArray,
        image_uri: ByteArray,
    );
    fn publish_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn hide_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn whitelist_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn blacklist_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn register_achievement(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16,
    );
    fn update_achievement(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16,
    );
    fn publish_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn hide_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn whitelist_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
    fn blacklist_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
}

#[dojo::contract]
pub mod Registrer {
    // Starknet imports

    use starknet::{ContractAddress, get_block_timestamp, get_contract_address};

    // Dojo imports

    use dojo::world::WorldStorage;
    use dojo::contract::{IContractDispatcher, IContractDispatcherTrait};

    // Internal imports

    use achievement::components::registrable::RegistrableComponent;

    // Local imports

    use super::IRegistrer;

    // Components

    component!(path: RegistrableComponent, storage: registrable, event: RegistrableEvent);
    impl InternalImpl = RegistrableComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub registrable: RegistrableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        RegistrableEvent: RegistrableComponent::Event
    }

    #[abi(embed_v0)]
    impl RegistrerImpl of IRegistrer<ContractState> {
        fn register_game(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            name: ByteArray,
            description: ByteArray,
            torii_url: ByteArray,
            image_uri: ByteArray,
            owner: felt252,
        ) {
            self
                .registrable
                .register_game(
                    self.world_storage(),
                    world_address,
                    namespace,
                    name,
                    description,
                    torii_url,
                    image_uri,
                    owner
                );
        }

        fn update_game(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            name: ByteArray,
            description: ByteArray,
            torii_url: ByteArray,
            image_uri: ByteArray,
        ) {
            self
                .registrable
                .update_game(
                    self.world_storage(),
                    world_address,
                    namespace,
                    name,
                    description,
                    torii_url,
                    image_uri
                );
        }

        fn publish_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registrable.publish_game(self.world_storage(), world_address, namespace);
        }

        fn hide_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registrable.hide_game(self.world_storage(), world_address, namespace);
        }

        fn whitelist_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registrable.whitelist_game(self.world_storage(), world_address, namespace);
        }

        fn blacklist_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            self.registrable.blacklist_game(self.world_storage(), world_address, namespace);
        }

        fn register_achievement(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            self
                .registrable
                .register_achievement(
                    self.world_storage(), world_address, namespace, identifier, karma
                );
        }

        fn update_achievement(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            self
                .registrable
                .update_achievement(
                    self.world_storage(), world_address, namespace, identifier, karma
                );
        }

        fn publish_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self
                .registrable
                .publish_achievement(self.world_storage(), world_address, namespace, identifier);
        }

        fn hide_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self
                .registrable
                .hide_achievement(self.world_storage(), world_address, namespace, identifier);
        }

        fn whitelist_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self
                .registrable
                .whitelist_achievement(self.world_storage(), world_address, namespace, identifier);
        }

        fn blacklist_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            self
                .registrable
                .blacklist_achievement(self.world_storage(), world_address, namespace, identifier);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@"namespace")
        }
    }
}
