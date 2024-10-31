#[starknet::component]
mod RegistrableComponent {
    // Dojo imports

    use dojo::world::WorldStorage;

    // Internal imports

    use achievement::store::{Store, StoreTrait};
    use achievement::models::game::{Game, GameTrait, GameAssert};
    use achievement::models::achievement::{Achievement, AchievementTrait, AchievementAssert};

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
        fn register_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            name: ByteArray,
            description: ByteArray,
            torii_url: ByteArray,
            image_uri: ByteArray,
            owner: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game does not exist
            let game = store.get_game(world_address, namespace);
            game.assert_does_not_exist();

            // [Effect] Create game
            let game = GameTrait::new(
                world_address, namespace, name, description, torii_url, image_uri, owner
            );

            // [Effect] Store game
            store.set_game(game);
        }

        fn update_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            name: ByteArray,
            description: ByteArray,
            torii_url: ByteArray,
            image_uri: ByteArray,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Effect] Update game
            game.update(name, description, torii_url, image_uri);

            // [Effect] Update game
            store.set_game(game);
        }

        fn publish_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Effect] Publish game
            game.publish();

            // [Effect] Store game
            store.set_game(game);
        }

        fn hide_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Effect] Hide game
            game.hide();

            // [Effect] Store game
            store.set_game(game);
        }

        fn whitelist_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Effect] Whitelist game
            game.whitelist();

            // [Effect] Store game
            store.set_game(game);
        }

        fn blacklist_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Effect] Blacklist game
            game.blacklist();

            // [Effect] Store game
            store.set_game(game);
        }

        fn remove_game(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Effect] Remove game
            game.nullify();

            // [Effect] Store game
            store.set_game(game);
        }

        fn register_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement does not exist
            let achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_not_exist();

            // [Effect] Create achievement
            let achievement = AchievementTrait::new(world_address, namespace, identifier, karma);

            // [Effect] Add achievement to game
            game.add(achievement.karma);

            // [Effect] Store entities
            store.set_achievement(achievement);
            store.set_game(game);
        }

        fn update_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
            karma: u16,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement exists
            let mut achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_exist();

            // [Effect] Update achievement and game
            game.remove(achievement.karma);
            achievement.update(karma);
            game.add(achievement.karma);

            // [Effect] Update entities
            store.set_achievement(achievement);
            store.set_game(game);
        }

        fn publish_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement exists
            let mut achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_exist();

            // [Effect] Publish achievement
            achievement.publish();

            // [Effect] Store achievement
            store.set_achievement(achievement);
        }

        fn hide_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement exists
            let mut achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_exist();

            // [Effect] Hide achievement
            achievement.hide();

            // [Effect] Store achievement
            store.set_achievement(achievement);
        }

        fn whitelist_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement exists
            let mut achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_exist();

            // [Effect] Whitelist achievement
            achievement.whitelist();

            // [Effect] Store achievement
            store.set_achievement(achievement);
        }

        fn blacklist_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement exists
            let mut achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_exist();

            // [Effect] Blacklist achievement
            achievement.blacklist();

            // [Effect] Store achievement
            store.set_achievement(achievement);
        }

        fn remove_achievement(
            self: @ComponentState<TContractState>,
            world: WorldStorage,
            world_address: felt252,
            namespace: felt252,
            identifier: felt252,
        ) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.get_game(world_address, namespace);
            game.assert_does_exist();

            // [Check] Achievement exists
            let mut achievement = store.get_achievement(world_address, namespace, identifier);
            achievement.assert_does_exist();

            // [Effect] Remove achievement
            game.remove(achievement.karma);
            achievement.nullify();

            // [Effect] Store entities
            store.set_achievement(achievement);
            store.set_game(game);
        }
    }
}
