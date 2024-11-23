// Internal imports

use achievement::events::index::TrophyPinning;

// Errors

pub mod errors {
    pub const PINNING_INVALID_ID: felt252 = 'Pinning: invalid id';
}

// Implementations

#[generate_trait]
impl PinningImpl of PinningTrait {
    #[inline]
    fn new(player_id: felt252, achievement_id: felt252, time: u64) -> TrophyPinning {
        // [Check] Inputs
        PinningAssert::assert_valid_id(achievement_id);
        // [Return] Pinning
        TrophyPinning { player_id, achievement_id, time }
    }
}

#[generate_trait]
impl PinningAssert of AssertTrait {
    #[inline]
    fn assert_valid_id(achievement_id: felt252) {
        assert(achievement_id != 0, errors::PINNING_INVALID_ID);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::PinningTrait;

    // Constants

    const PLAYER_ID: felt252 = 'PLAYER';
    const ACHIEVEMENT_ID: felt252 = 'ACHIEVEMENT';
    const TIME: u64 = 1000000000;

    #[test]
    fn test_pinning_new() {
        let pinning = PinningTrait::new(PLAYER_ID, ACHIEVEMENT_ID, TIME,);
        assert_eq!(pinning.player_id, PLAYER_ID);
        assert_eq!(pinning.achievement_id, ACHIEVEMENT_ID);
        assert_eq!(pinning.time, TIME);
    }

    #[test]
    #[should_panic(expected: ('Pinning: invalid id',))]
    fn test_pinning_new_invalid_id() {
        PinningTrait::new(PLAYER_ID, 0, TIME);
    }
}
