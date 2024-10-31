// Interfaces

#[starknet::interface]
trait IActions<TContractState> {
    fn register_game(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        name: ByteArray,
        description: ByteArray,
        torii_url: ByteArray,
        image_uri: ByteArray
    );
    fn update_game(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        name: ByteArray,
        description: ByteArray,
        torii_url: ByteArray,
        image_uri: ByteArray
    );
    fn publish_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn hide_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn whitelist_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn blacklist_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn remove_game(self: @TContractState, world_address: felt252, namespace: felt252);
    fn register_achievement(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16
    );
    fn update_achievement(
        self: @TContractState,
        world_address: felt252,
        namespace: felt252,
        identifier: felt252,
        karma: u16
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
    fn remove_achievement(
        self: @TContractState, world_address: felt252, namespace: felt252, identifier: felt252
    );
}

// Contracts

#[dojo::contract]
mod Actions {
    // Core imports

    use core::poseidon::poseidon_hash_span;

    // Starknet imports

    use starknet::get_caller_address;

    // Dojo imports

    use dojo::world::WorldStorage;

    // Component imports

    use achievement::components::controllable::ControllableComponent;
    use achievement::components::registrable::RegistrableComponent;

    // Local imports

    use super::IActions;

    // Components

    component!(path: ControllableComponent, storage: controllable, event: ControllableEvent);
    impl ControllableInternalImpl = ControllableComponent::InternalImpl<ContractState>;
    component!(path: RegistrableComponent, storage: registrable, event: RegistrableEvent);
    impl RegistrableInternalImpl = RegistrableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        controllable: ControllableComponent::Storage,
        #[substorage(v0)]
        registrable: RegistrableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ControllableEvent: ControllableComponent::Event,
        #[flat]
        RegistrableEvent: RegistrableComponent::Event,
    }

    // Errors

    mod errors {
        const ACTIONS_CALLER_NOT_OWNER: felt252 = 'Actions: caller not owner';
    }

    // Implementations

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn register_game(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            name: ByteArray,
            description: ByteArray,
            torii_url: ByteArray,
            image_uri: ByteArray,
        ) {
            let owner: felt252 = get_caller_address().into();
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
                )
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
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Update game
            self
                .registrable
                .update_game(
                    world, world_address, namespace, name, description, torii_url, image_uri
                )
        }

        fn publish_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Publish game
            self.registrable.publish_game(world, world_address, namespace);
        }

        fn hide_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Hide game
            self.registrable.hide_game(world, world_address, namespace);
        }

        fn whitelist_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            // [Check] Caller is a resource owner or writer
            let world = self.world_storage();
            // self.controllable.assert_is_authorized(world);
            // [Effect] Whitelist game
            self.registrable.whitelist_game(world, world_address, namespace);
        }

        fn blacklist_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            // [Check] Caller is a resource owner or writer
            let world = self.world_storage();
            // self.controllable.assert_is_authorized(world);
            // [Effect] Blacklist game
            self.registrable.blacklist_game(world, world_address, namespace);
        }

        fn remove_game(self: @ContractState, world_address: felt252, namespace: felt252) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Remove game
            self.registrable.remove_game(world, world_address, namespace)
        }

        fn register_achievement(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Register achievement
            self
                .registrable
                .register_achievement(world, world_address, namespace, identifier, karma)
        }

        fn update_achievement(
            self: @ContractState,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Update achievement
            self.registrable.update_achievement(world, world_address, namespace, identifier, karma)
        }

        fn publish_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Publish achievement
            self.registrable.publish_achievement(world, world_address, namespace, identifier);
        }

        fn hide_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Whitelist achievement
            self.registrable.whitelist_achievement(world, world_address, namespace, identifier);
        }

        fn whitelist_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            // [Check] Caller is a resource owner or writer
            let world = self.world_storage();
            // self.controllable.assert_is_authorized(world);
            // [Effect] Whitelist achievement
            self.registrable.whitelist_achievement(world, world_address, namespace, identifier);
        }

        fn blacklist_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            // [Check] Caller is a resource owner or writer
            let world = self.world_storage();
            // self.controllable.assert_is_authorized(world);
            // [Effect] Blacklist achievement
            self.registrable.blacklist_achievement(world, world_address, namespace, identifier);
        }

        fn remove_achievement(
            self: @ContractState, world_address: felt252, namespace: felt252, identifier: felt252
        ) {
            // [Check] Caller is the game owner
            let world = self.world_storage();
            self.controllable.assert_is_owner(world, world_address, namespace);
            // [Effect] Remove achievement
            self.registrable.remove_achievement(world, world_address, namespace, identifier);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn world_storage(self: @ContractState) -> WorldStorage {
            self.world(@"game_center")
        }
    }
}
