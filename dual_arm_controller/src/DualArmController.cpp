#include "DualArmController.h"

#include <mc_rbdyn/RobotLoader.h>

DualArmController::DualArmController(mc_rbdyn::RobotModulePtr rm, double dt,
                                     const mc_rtc::Configuration &config)
    : mc_control::MCController(
          {rm,
          mc_rbdyn::RobotLoader::get_robot_module(
              "env",
              "/usr/local/share/mc_kinova",
              std::string("kinova_default"))},
          dt) {
  solver().addConstraintSet(contactConstraint);
  solver().addConstraintSet(kinematicsConstraint);
  solver().addTask(postureTask);
  solver().setContacts({{}});

  mc_rtc::log::success("DualArmController init done ");
}

bool DualArmController::run() { return mc_control::MCController::run(); }

void DualArmController::reset(
    const mc_control::ControllerResetData &reset_data) {
  mc_control::MCController::reset(reset_data);
}

CONTROLLER_CONSTRUCTOR("DualArmController", DualArmController)
