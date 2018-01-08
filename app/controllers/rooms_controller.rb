class RoomsController < ApplicationController
  def index
    @room = Search::Room.new
    @rooms = Room.all
    @options = Plan.pluck(:name, :id)
  end

  def show
    @room = Room.joins('JOIN class_rooms ON class_rooms.id = rooms.class_room_id').select('rooms.*, class_rooms.*').find(params[:id])
    @plans = PlanRoom.joins('JOIN plans ON plans.id = plan_rooms.plan_id').select('plans.*').where('plan_rooms.room_id = ?', params[:id])
  end

  def search
    @options = Plan.pluck(:name, :id)
    @room = Search::Room.new(search_params)
    @rooms = @room
                  .matches
                  .order('rooms.id')
    render 'index'
  end

  private
  # 検索フォームから受け取ったパラメータ
  def search_params
    params
      .require(:search_room)
      .permit(Search::Room::ATTRIBUTES)
  end
end
