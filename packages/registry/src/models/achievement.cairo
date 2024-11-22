// Internal imports

use registry::models::index::Achievement;
use registry::constants;

// Errors

pub mod errors {
    pub const ACHIEVEMENT_ALREADY_EXISTS: felt252 = 'Achievement: already exists';
    pub const ACHIEVEMENT_NOT_EXIST: felt252 = 'Achievement: does not exist';
    pub const ACHIEVEMENT_INVALID_WORLD: felt252 = 'Achievement: invalid world';
    pub const ACHIEVEMENT_INVALID_NAMESPACE: felt252 = 'Achievement: invalid namespace';
    pub const ACHIEVEMENT_INVALID_ACHIEVEMENT: felt252 = 'Achievement: invalid id';
    pub const ACHIEVEMENT_TOO_MUCH_KARMA: felt252 = 'Achievement: cannot exceed 100';
    pub const ACHIEVEMENT_TOO_FEW_KARMA: felt252 = 'Achievement: must be at least 1';
    pub const ACHIEVEMENT_NOT_WHITELISTABLE: felt252 = 'Achievement: not whitelistable';
    pub const ACHIEVEMENT_ALREADY_WHITELISTED: felt252 = 'Achievement: already listed';
}

#[generate_trait]
impl AchievementImpl of AchievementTrait {
    #[inline]
    fn new(
        world_address: felt252, namespace: felt252, identifier: felt252, karma: u16
    ) -> Achievement {
        // [Check] Inputs
        AchievementAssert::assert_valid_world(world_address);
        AchievementAssert::assert_valid_namespace(namespace);
        AchievementAssert::assert_valid_achievement(identifier);
        AchievementAssert::assert_valid_karma(karma);
        // [Return] Achievement
        Achievement {
            world_address, namespace, id: identifier, published: false, whitelisted: false, karma,
        }
    }

    #[inline]
    fn publish(ref self: Achievement) {
        // [Effect] Set visibility status
        self.published = true;
        self.whitelisted = false;
    }

    #[inline]
    fn hide(ref self: Achievement) {
        // [Effect] Reset visibility status
        self.published = false;
        self.whitelisted = false;
    }

    #[inline]
    fn whitelist(ref self: Achievement) {
        // [Check] Achievement is whitelistable
        AchievementAssert::assert_is_whitelistable(self);
        // [Effect] Whitelist
        self.whitelisted = true;
    }

    #[inline]
    fn blacklist(ref self: Achievement) {
        // [Effect] Reset visibility status
        self.published = false;
        self.whitelisted = false;
    }

    #[inline]
    fn update(ref self: Achievement, karma: u16) {
        // [Check] Inputs
        AchievementAssert::assert_valid_karma(karma);
        // [Effect] Update Points
        self.karma = karma;
        // [EFfect] Reset visibility status
        self.published = false;
        self.whitelisted = false;
    }

    #[inline]
    fn nullify(ref self: Achievement) {
        self.karma = 0;
        self.published = false;
        self.whitelisted = false;
    }
}

#[generate_trait]
impl AchievementAssert of AssertTrait {
    #[inline]
    fn assert_does_not_exist(self: Achievement) {
        assert(self.karma == 0, errors::ACHIEVEMENT_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: Achievement) {
        assert(self.karma != 0, errors::ACHIEVEMENT_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_world(world: felt252) {
        assert(world != 0, errors::ACHIEVEMENT_INVALID_WORLD);
    }

    #[inline]
    fn assert_valid_namespace(namespace: felt252) {
        assert(namespace != 0, errors::ACHIEVEMENT_INVALID_NAMESPACE);
    }

    #[inline]
    fn assert_valid_achievement(achivement_id: felt252) {
        assert(achivement_id != 0, errors::ACHIEVEMENT_INVALID_ACHIEVEMENT);
    }

    #[inline]
    fn assert_valid_karma(karma: u16) {
        assert(karma >= constants::MIN_ACHIEVEMENT_KARMA, errors::ACHIEVEMENT_TOO_FEW_KARMA);
        assert(karma <= constants::MAX_ACHIEVEMENT_KARMA, errors::ACHIEVEMENT_TOO_MUCH_KARMA);
    }

    #[inline]
    fn assert_is_whitelistable(self: Achievement) {
        assert(self.published, errors::ACHIEVEMENT_NOT_WHITELISTABLE);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Achievement, AchievementTrait, AchievementAssert};

    // Constants

    const WORLD_ADDRESS: felt252 = 'WORLD';
    const NAMESPACE: felt252 = 'NAMESPACE';
    const IDENTIFIER: felt252 = 'ID';
    const KARMA: u16 = 42;

    #[test]
    fn test_achievement_new() {
        let achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        assert_eq!(achievement.world_address, WORLD_ADDRESS);
        assert_eq!(achievement.namespace, NAMESPACE);
        assert_eq!(achievement.id, IDENTIFIER);
        assert_eq!(achievement.karma, KARMA);
    }

    #[test]
    fn test_achievement_publish() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.publish();
        assert_eq!(achievement.published, true);
    }

    #[test]
    fn test_achievement_hide() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.publish();
        achievement.hide();
        assert_eq!(achievement.published, false);
    }

    #[test]
    fn test_achievement_whitelist() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.publish();
        achievement.whitelist();
        assert_eq!(achievement.whitelisted, true);
    }

    #[test]
    fn test_achievement_blacklist() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.publish();
        achievement.whitelist();
        achievement.blacklist();
        assert_eq!(achievement.whitelisted, false);
    }

    #[test]
    fn test_achievement_update() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.update(KARMA + 1);
        assert_eq!(achievement.karma, KARMA + 1);
    }

    #[test]
    fn test_achievement_nullify() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.nullify();
        assert_eq!(achievement.karma, 0);
        assert_eq!(achievement.whitelisted, false);
    }

    #[test]
    #[should_panic(expected: 'Achievement: cannot exceed 100')]
    fn test_achievement_set_karma_exceeds_max() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.update(101);
    }

    #[test]
    #[should_panic(expected: 'Achievement: invalid world')]
    fn test_achievement_assert_valid_world_zero() {
        AchievementAssert::assert_valid_world(0);
    }

    #[test]
    #[should_panic(expected: 'Achievement: invalid namespace')]
    fn test_achievement_assert_valid_namespace_zero() {
        AchievementAssert::assert_valid_namespace(0);
    }

    #[test]
    #[should_panic(expected: 'Achievement: invalid id')]
    fn test_achievement_assert_valid_achievement_zero() {
        AchievementAssert::assert_valid_achievement(0);
    }

    #[test]
    #[should_panic(expected: 'Achievement: must be at least 1')]
    fn test_achievement_assert_valid_karma_too_few() {
        AchievementAssert::assert_valid_karma(0);
    }

    #[test]
    #[should_panic(expected: 'Achievement: cannot exceed 100')]
    fn test_achievement_assert_valid_karma_exceeds_max() {
        AchievementAssert::assert_valid_karma(101);
    }

    #[test]
    #[should_panic(expected: 'Achievement: not whitelistable')]
    fn test_achievement_assert_is_whitelistable_not_published() {
        let mut achievement = AchievementTrait::new(WORLD_ADDRESS, NAMESPACE, IDENTIFIER, KARMA);
        achievement.publish();
        achievement.hide();
        achievement.whitelist();
        AchievementAssert::assert_is_whitelistable(achievement);
    }
}
