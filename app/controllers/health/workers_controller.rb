module Health
  class WorkersController < ApplicationController
    def index
      WorkerHealthChecker.enqueue_dummy_jobs

      summary = WorkerHealthChecker.summary

      status = summary.all_healthy? ? :ok : :internal_error

      render json: summary, status: status
    end
  end
end
