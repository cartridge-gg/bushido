// Internal imports

use provider::models::index::Deployment;
use provider::types::service::Service;
use provider::types::status::Status;
use provider::types::tier::Tier;

// Errors

pub mod errors {
    pub const DEPLOYMENT_ALREADY_EXISTS: felt252 = 'Deployment: already exists';
    pub const DEPLOYMENT_NOT_EXIST: felt252 = 'Deployment: does not exist';
    pub const DEPLOYMENT_INVALID_SERVICE: felt252 = 'Deployment: invalid service';
    pub const DEPLOYMENT_INVALID_PROJECT: felt252 = 'Deployment: invalid project';
    pub const DEPLOYMENT_INVALID_STATUS: felt252 = 'Deployment: invalid status';
    pub const DEPLOYMENT_INVALID_TIER: felt252 = 'Deployment: invalid tier';
}

#[generate_trait]
impl DeploymentImpl of DeploymentTrait {
    #[inline]
    fn new(service: Service, project: felt252, tier: Tier, config: ByteArray,) -> Deployment {
        // [Check] Inputs
        DeploymentAssert::assert_valid_service(service);
        DeploymentAssert::assert_valid_project(project);
        DeploymentAssert::assert_valid_tier(tier);
        // [Return] Deployment
        Deployment {
            service: service.into(),
            project: project,
            status: Status::Disabled.into(),
            tier: tier.into(),
            config: config,
        }
    }

    #[inline]
    fn nullify(ref self: Deployment) {
        self.project = 0;
    }
}

#[generate_trait]
impl DeploymentAssert of AssertTrait {
    #[inline]
    fn assert_does_not_exist(self: @Deployment) {
        assert(self.project == @0, errors::DEPLOYMENT_ALREADY_EXISTS);
    }

    #[inline]
    fn assert_does_exist(self: @Deployment) {
        assert(self.project != @0, errors::DEPLOYMENT_NOT_EXIST);
    }

    #[inline]
    fn assert_valid_service(service: Service) {
        assert(service != Service::None, errors::DEPLOYMENT_INVALID_SERVICE);
    }

    #[inline]
    fn assert_valid_project(project: felt252) {
        assert(project != 0, errors::DEPLOYMENT_INVALID_PROJECT);
    }

    #[inline]
    fn assert_valid_status(status: Status) {
        assert(status != Status::None, errors::DEPLOYMENT_INVALID_STATUS);
    }

    #[inline]
    fn assert_valid_tier(tier: Tier) {
        assert(tier != Tier::None, errors::DEPLOYMENT_INVALID_TIER);
    }
}

#[cfg(test)]
mod tests {
    // Local imports

    use super::{Deployment, DeploymentTrait, DeploymentAssert, Service, Status, Tier};

    // Constants

    const SERVICE: Service = Service::Katana;
    const PROJECT: felt252 = 'PROJECT';
    const TIER: Tier = Tier::Basic;

    #[test]
    fn test_deployment_new() {
        let deployment = DeploymentTrait::new(SERVICE, PROJECT, TIER, "");
        assert_eq!(deployment.service, SERVICE.into());
        assert_eq!(deployment.project, PROJECT);
        assert_eq!(deployment.tier, TIER.into());
        assert_eq!(deployment.config, "");
    }

    #[test]
    fn test_deployment_assert_does_exist() {
        let deployment = DeploymentTrait::new(SERVICE, PROJECT, TIER, "");
        deployment.assert_does_exist();
    }

    #[test]
    #[should_panic(expected: 'Deployment: already exists')]
    fn test_deployment_revert_already_exists() {
        let mut deployment = DeploymentTrait::new(SERVICE, PROJECT, TIER, "");
        deployment.assert_does_not_exist();
    }
}
