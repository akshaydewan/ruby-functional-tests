##########################################################################
# Copyright 2018 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

@auto_refresh = false

step 'On Swift Dashboard Page' do |_tmp|
  new_pipeline_dashboard_page.load(autoRefresh: @auto_refresh)
end

step 'Turn on AutoRefresh - On Swift Dashboard page' do |_pipeline|
  @auto_refresh = true
end

step 'Trigger pipeline - On Swift Dashboard page' do |_tmp|
  new_pipeline_dashboard_page.trigger_pipeline
end

step 'Looking at pipeline <pipeline> - On Swift Dashboard page' do |pipeline|
  new_pipeline_dashboard_page.load(autoRefresh: @auto_refresh)
  scenario_state.set_current_pipeline pipeline
end

step 'Turn off AutoRefresh - On Swift Dashboard page' do |_pipeline|
  @auto_refresh = false
end

step 'Wait till stage <stage> completed - On Swift Dashboard page' do |stage|
  new_pipeline_dashboard_page.wait_till_stage_complete scenario_state.current_pipeline, stage
end

step 'Wait till pipeline completed - On Swift Dashboard page' do |_stage|
  new_pipeline_dashboard_page.wait_till_pipeline_complete scenario_state.current_pipeline
end

step 'Verify stage <stage> is <state> - On Swift Dashboard page' do |stage, state|
  new_pipeline_dashboard_page.verify_pipeline_stage_state scenario_state.current_pipeline, stage, state.downcase
end

step 'Verify stage <stage> is <state> on pipeline with label <label> - On Swift Dashboard page' do |stage, state, label|
  new_pipeline_dashboard_page.verify_pipeline_stage_state scenario_state.current_pipeline, stage, state
  new_pipeline_dashboard_page.verify_pipeline_is_at_label scenario_state.current_pipeline, label
end

step 'Verify pipeline <pipeline> shows up - On Swift Dashboard page' do |pipeline|
  new_pipeline_dashboard_page.load(autoRefresh: @auto_refresh)
  new_pipeline_dashboard_page.wait_till_pipeline_showsup pipeline
end

step 'Verify pipeline <pipeline> do not show up - On Swift Dashboard page' do |pipeline|
  new_pipeline_dashboard_page.load(autoRefresh: @auto_refresh)
  assert_raise RuntimeError do
    new_pipeline_dashboard_page.wait_till_pipeline_showsup pipeline
  end
end

step 'Verify pipeline is editable - On Swift Dashboard page' do |pipeline|
  assert_true new_pipeline_dashboard_page.editable?
end

step 'Verify pipeline is not editable - On Swift Dashboard page' do |pipeline|
  assert_false new_pipeline_dashboard_page.editable?
end

step 'Verify pipeline is locked - On Swift Dashboard page' do |pipeline|
  assert_true new_pipeline_dashboard_page.locked?
end

step 'Verify pipeline is not locked - On Swift Dashboard page' do |pipeline|
  assert_false new_pipeline_dashboard_page.locked?
end

step 'Verify pipeline <pipeline> is not visible - On Swift Dashboard page' do |pipeline|
  assert_false new_pipeline_dashboard_page.visible?(pipeline)
end

step 'Verify group <group> is not visible - On Swift Dashboard page' do |group|
  assert_false new_pipeline_dashboard_page.group_visible?(group)
end

step 'Verify group <group> is visible - On Swift Dashboard page' do |group|
  assert_true new_pipeline_dashboard_page.group_visible?(group)
end

step 'Verify pipeline is in group <group> - On Swift Dashboard page' do |group|
  assert_true new_pipeline_dashboard_page.pipeline_in_group?(group)
end

step 'Verify pipeline has no history - On Swift Dashboard page' do |_tmp|
  assert_true new_pipeline_dashboard_page.pipeline_history_exists?
end

step 'Verify pipeline is triggered by <user> - On Swift Dashboard page' do |user|
  assert_true new_pipeline_dashboard_page.triggered_by? user
end

step 'Pause pipeline with reason <message> - On Swift Dashboard page' do |message|
  new_pipeline_dashboard_page.pause_pipeline(message)
end

step 'Verify pipeline is paused with reason <reason> by <user> - On Swift Dashboard page' do |reason, user|
  new_pipeline_dashboard_page.pause_message?("Paused by #{user} (#{reason})")
end

step 'Unpause pipeline - On Swift Dashboard page' do |tmp|
  new_pipeline_dashboard_page.unpause_pipeline
end

step 'Click on history - On Swift Dashboard page' do |tmp|
  new_pipeline_dashboard_page.click_history
end

step 'Open changes section - On Swift Dashboard page' do |tmp|
  new_pipeline_dashboard_page.open_build_cause
end

step 'Verify can trigger pipeline' do |tmp|
  assert_false new_pipeline_dashboard_page.trigger_pipeline_disabled?
end

step 'Looking at material of type <material_type> named <name> verify shows latest revision - On Swift Dashboard page' do |type, name|
  latest_revision = Context::GitMaterials.new(basic_configuration.material_url_for(scenario_state.self_pipeline)).latest_revision
  revision = new_pipeline_dashboard_page.revision_of_material(type, name)
  new_pipeline_dashboard_page.shows_revision?(revision, latest_revision)
end

step 'Checkin file <filename> as user <user> with message <message> - On Swift Dashboard page' do |filename, user, message|
  Context::GitMaterials.new(basic_configuration.material_url_for(scenario_state.self_pipeline)).new_commit(filename, message, user)
end

step 'Open trigger with options - On Swift Dashboard page' do |_tmp|
  new_pipeline_dashboard_page.trigger_pipeline_with_options
end

step 'Verify last run revision is <identifier> - On Swift Dashboard page' do |revision_id|
  assert_true new_pipeline_dashboard_page.last_run_revision.eql? scenario_state.material_revision revision_id
end

step 'Close - Trigger with options - On Swift Dashboard page' do |_tmp|
  new_pipeline_dashboard_page.close_trigger_with_options
end

step 'Trigger pipeline with options - On Swift Dashboard page' do |_tmp|
  new_pipeline_dashboard_page.trigger_with_options
end

step 'Using material <material_name> set revision to trigger with as <identifier> - On Swift Dashboard page' do |material_name, identifier|
  new_pipeline_dashboard_page.set_revision_to_trigger_with(material_name, identifier)
end

step 'Verify cannot trigger pipeline' do |_tmp|
  assert_true new_pipeline_dashboard_page.trigger_pipeline_disabled?
end

step 'Verify trigger with option is disabled' do |_tmp|
  assert_true new_pipeline_dashboard_page.trigger_pipeline_with_options_disabled?
end

step 'Open pipelines selector - On Swift Dashboard page' do |_tmp|
  new_pipeline_dashboard_page.load(autoRefresh: @auto_refresh)
  new_pipeline_dashboard_page.open_pipeline_selector_dropdown
end
