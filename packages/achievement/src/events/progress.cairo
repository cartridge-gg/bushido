// Internal imports

use achievement::events::index::TrophyProgression;

// Errors

pub mod errors {
    pub const PROGRESS_INVALID_TASK: felt252 = 'Progress: invalid task';
}

// Implementations

#[generate_trait]
impl ProgressImpl of ProgressTrait {
    #[inline]
    fn new(player_id: felt252, task_id: felt252, count: u32, time: u64,) -> TrophyProgression {
        // [Check] Inputs
        ProgressAssert::assert_valid_task(task_id);
        // [Return] Progress
        TrophyProgression { player_id, task_id, count, time }
    }
}

#[generate_trait]
impl ProgressAssert of AssertTrait {
    #[inline]
    fn assert_valid_task(task_id: felt252) {
        assert(task_id != 0, errors::PROGRESS_INVALID_TASK);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::ProgressTrait;

    // Constants

    const PLAYER_ID: felt252 = 'PLAYER';
    const TASK_ID: felt252 = 'TASK';
    const COUNT: u32 = 100;
    const TIME: u64 = 1000000000;

    #[test]
    fn test_achievement_progress_new() {
        let progress = ProgressTrait::new(PLAYER_ID, TASK_ID, COUNT, TIME,);

        assert_eq!(progress.player_id, PLAYER_ID);
        assert_eq!(progress.task_id, TASK_ID);
        assert_eq!(progress.count, COUNT);
        assert_eq!(progress.time, TIME);
    }
    #[test]
    #[should_panic(expected: ('Progress: invalid task',))]
    fn test_achievement_progress_new_invalid_task() {
        ProgressTrait::new(PLAYER_ID, 0, COUNT, TIME);
    }
}
