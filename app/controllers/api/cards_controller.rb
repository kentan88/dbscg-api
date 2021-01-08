class API::CardsController < ApplicationController
  def index
    # main_deck_cards = [
    #   "SD1-01",
    #   "BT1-033",
    #   "BT1-040",
    #   "BT1-050",
    #   "BT1-054",
    #   "BT1-055",
    #   "BT1-035",
    #   "BT1-039",
    #   "BT1-046",
    #   "BT1-037",
    #   "SD1-04",
    #   "BT1-034",
    #   "BT1-042",
    #   "BT1-044",
    #   "SD1-03",
    #   "SD1-05",
    #   "SD1-02"
    # ]

    main_deck_cards = [
      "SD8-01",
      "SD8-05",
      "BT6-063",
      "BT6-065",
      "BT6-069",
      "BT6-076",
      "BT6-078",
      "BT1-107",
      "BT1-109",
      "SD8-09",
      "SD8-10",
      "SD8-04",
      "SD8-06",
      "SD8-03",
      "BT6-062",
      "SD8-07",
      "SD8-08",
      "SD8-02"
    ]

    @cards = Card.where(number: main_deck_cards).order(:number)






    # q = Card.order(energy_cost: :asc, title: :asc).ransack(params[:q])
    # @cards = q.result(distinct: true).page(params[:page]).per(25)

    # result_hash = {}
    # @cards.each do |card|
    #   result_hash[card.number] = card.as_json.reject { |key| key == "skills" || key == "skills_back" }
    # end
    #
    # render json: result_hash
  end
end