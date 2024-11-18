// Intenral imports

use arcade_slot::models::index::Game;

// Errors

pub mod errors {
    pub const GAME_ALREADY_EXISTS: felt252 = 'Game: already exists';
    pub const GAME_NOT_EXIST: felt252 = 'Game: does not exist';
    pub const GAME_INVALID_IDENTIFIER: felt252 = 'Game: invalid identifier';
    pub const GAME_INVALID_NAME: felt252 = 'Game: invalid name';
    pub const GAME_INVALID_PRIORITY: felt252 = 'Game: invalid priority';
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline]
    fn new(
        id: felt252, name: felt252, description: ByteArray, socials: ByteArray, metadata: ByteArray,
    ) -> Game {
        // [Check] Inputs
        GameAssert::assert_valid_identifier(id);
        GameAssert::assert_valid_name(name);
        // [Return] Game
        Game {
            id: id,
            name: name,
            description: description,
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
    fn assert_does_not_exist(self: Game) {
        assert(self.name == 0, errors::GAME_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: Game) {
        assert(self.name != 0, errors::GAME_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_identifier(identifier: felt252) {
        assert(identifier != 0, errors::GAME_INVALID_IDENTIFIER);
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

    const IDENTIFIER: felt252 = 'ID';
    const NAME: felt252 = 'NAME';

    #[test]
    fn test_service_new() {
        let service = GameTrait::new(IDENTIFIER, NAME, "", "", "");
        assert_eq!(service.id, IDENTIFIER);
        assert_eq!(service.name, NAME);
        assert_eq!(service.description, "");
        assert_eq!(service.socials, "");
        assert_eq!(service.metadata, "");
        assert_eq!(service.active, true);
    }

    #[test]
    fn test_service_assert_does_exist() {
        let service = GameTrait::new(IDENTIFIER, NAME, "", "", "");
        service.assert_does_exist();
    }

    #[test]
    #[should_panic(expected: 'Game: already exists')]
    fn test_service_revert_already_exists() {
        let service = GameTrait::new(IDENTIFIER, NAME, "", "", "");
        service.assert_does_not_exist();
    }

    #[test]
    #[should_panic(expected: 'Game: invalid name')]
    fn test_service_revert_invalid_name() {
        GameTrait::new(IDENTIFIER, 0, "", "", "");
    }
}
