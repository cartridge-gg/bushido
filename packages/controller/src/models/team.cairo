// Intenral imports

use controller::models::index::Team;

// Errors

pub mod errors {
    pub const TEAM_ALREADY_EXISTS: felt252 = 'Team: already exists';
    pub const TEAM_NOT_EXIST: felt252 = 'Team: does not exist';
    pub const TEAM_INVALID_IDENTIFIER: felt252 = 'Team: invalid identifier';
    pub const TEAM_INVALID_NAME: felt252 = 'Team: invalid name';
}

#[generate_trait]
impl TeamImpl of TeamTrait {
    #[inline]
    fn new(id: felt252, name: felt252, description: ByteArray) -> Team {
        // [Check] Inputs
        TeamAssert::assert_valid_identifier(id);
        TeamAssert::assert_valid_name(name);
        // [Return] Team
        Team { id: id, name: name, description: description, }
    }
}

#[generate_trait]
impl TeamAssert of AssertTrait {
    #[inline]
    fn assert_does_not_exist(self: @Team) {
        assert(self.name == @0, errors::TEAM_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: @Team) {
        assert(self.name != @0, errors::TEAM_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_identifier(identifier: felt252) {
        assert(identifier != 0, errors::TEAM_INVALID_IDENTIFIER);
    }

    #[inline]
    fn assert_valid_name(name: felt252) {
        assert(name != 0, errors::TEAM_INVALID_NAME);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Team, TeamTrait, TeamAssert};

    // Constants

    const IDENTIFIER: felt252 = 'ID';
    const NAME: felt252 = 'NAME';

    #[test]
    fn test_deployment_new() {
        let team = TeamTrait::new(IDENTIFIER, 'NAME', "");
        assert_eq!(team.id, IDENTIFIER);
        assert_eq!(team.name, 'NAME');
        assert_eq!(team.description, "");
    }

    #[test]
    fn test_deployment_assert_does_exist() {
        let team = TeamTrait::new(IDENTIFIER, 'NAME', "");
        team.assert_does_exist();
    }

    #[test]
    #[should_panic(expected: 'Team: already exists')]
    fn test_deployment_revert_already_exists() {
        let team = TeamTrait::new(IDENTIFIER, 'NAME', "");
        team.assert_does_not_exist();
    }
}
