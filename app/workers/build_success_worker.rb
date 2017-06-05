class BuildSuccessWorker
  include Sidekiq::Worker
  include BuildQueue

  def perform(build_id)
    Ci::Build.find_by(id: build_id).try do |build|
      create_deployment(build) if build.has_environment?
    end
  end

  private

  def create_deployment(build)
    CreateDeploymentService.new(build).execute
  end
end
