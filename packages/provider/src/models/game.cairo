// Intenral imports

use provider::models::index::Game;

// Errors

pub mod errors {
    pub const GAME_ALREADY_EXISTS: felt252 = 'Game: already exists';
    pub const GAME_NOT_EXIST: felt252 = 'Game: does not exist';
    pub const GAME_INVALID_PROJECT: felt252 = 'Game: invalid project';
    pub const GAME_INVALID_OWNER: felt252 = 'Game: invalid owner';
    pub const GAME_INVALID_WORLD: felt252 = 'Game: invalid world';
    pub const GAME_INVALID_NAMESPACE: felt252 = 'Game: invalid namespace';
    pub const GAME_INVALID_NAME: felt252 = 'Game: invalid name';
    pub const GAME_INVALID_PRIORITY: felt252 = 'Game: invalid priority';
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline]
    fn new(
        project: felt252,
        owner: felt252,
        world: felt252,
        namespace: felt252,
        name: felt252,
        socials: ByteArray,
        metadata: ByteArray,
    ) -> Game {
        // [Check] Inputs
        GameAssert::assert_valid_project(project);
        GameAssert::assert_valid_owner(owner);
        GameAssert::assert_valid_name(name);
        GameAssert::assert_valid_world(world);
        GameAssert::assert_valid_namespace(namespace);
        // [Return] Game
        Game {
            project: project,
            owner: owner,
            world: world,
            namespace: namespace,
            name: name,
            priority: 0,
            socials: socials,
            metadata: metadata,
            active: true,
        }
    }
}

#[generate_trait]
impl GameAssert of AssertTrait {
    #[inline]
    fn assert_does_not_exist(self: @Game) {
        assert(self.name == @0, errors::GAME_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: @Game) {
        assert(self.name != @0, errors::GAME_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_project(project: felt252) {
        assert(project != 0, errors::GAME_INVALID_PROJECT);
    }

    #[inline]
    fn assert_valid_owner(owner: felt252) {
        assert(owner != 0, errors::GAME_INVALID_OWNER);
    }

    #[inline]
    fn assert_valid_world(world: felt252) {
        assert(world != 0, errors::GAME_INVALID_WORLD);
    }

    #[inline]
    fn assert_valid_namespace(namespace: felt252) {
        assert(namespace != 0, errors::GAME_INVALID_NAMESPACE);
    }

    #[inline]
    fn assert_valid_name(name: felt252) {
        assert(name != 0, errors::GAME_INVALID_NAME);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Game, GameTrait, GameAssert};

    // Constants

    const PROJECT: felt252 = 'PROJECT';
    const OWNER: felt252 = 'OWNER';
    const WORLD: felt252 = 'WORLD';
    const NAMESPACE: felt252 = 'NAMESPACE';
    const NAME: felt252 = 'NAME';

    #[test]
    fn test_service_new() {
        let service = GameTrait::new(PROJECT, OWNER, WORLD, NAMESPACE, NAME, "", "");
        assert_eq!(service.project, PROJECT);
        assert_eq!(service.owner, OWNER);
        assert_eq!(service.world, WORLD);
        assert_eq!(service.namespace, NAMESPACE);
        assert_eq!(service.name, NAME);
        assert_eq!(service.socials, "");
        assert_eq!(service.metadata, "");
        assert_eq!(service.active, true);
    }

    #[test]
    fn test_service_assert_does_exist() {
        let service = GameTrait::new(PROJECT, OWNER, WORLD, NAMESPACE, NAME, "", "");
        service.assert_does_exist();
    }

    #[test]
    #[should_panic(expected: 'Game: already exists')]
    fn test_service_revert_already_exists() {
        let service = GameTrait::new(PROJECT, OWNER, WORLD, NAMESPACE, NAME, "", "");
        service.assert_does_not_exist();
    }

    #[test]
    #[should_panic(expected: 'Game: invalid project')]
    fn test_service_revert_invalid_project() {
        GameTrait::new(0, OWNER, WORLD, NAMESPACE, NAME, "", "");
    }

    #[test]
    #[should_panic(expected: 'Game: invalid owner')]
    fn test_service_revert_invalid_owner() {
        GameTrait::new(PROJECT, 0, WORLD, NAMESPACE, NAME, "", "");
    }

    #[test]
    #[should_panic(expected: 'Game: invalid world')]
    fn test_service_revert_invalid_world() {
        GameTrait::new(PROJECT, OWNER, 0, NAMESPACE, NAME, "", "");
    }

    #[test]
    #[should_panic(expected: 'Game: invalid namespace')]
    fn test_service_revert_invalid_namespace() {
        GameTrait::new(PROJECT, OWNER, WORLD, 0, NAME, "", "");
    }

    #[test]
    #[should_panic(expected: 'Game: invalid name')]
    fn test_service_revert_invalid_name() {
        GameTrait::new(PROJECT, OWNER, WORLD, NAMESPACE, 0, "", "");
    }
}
