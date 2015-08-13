module CommonStoryCards

  def initialize_common_cards
    [
        %w(STU Stand Up),
        %w(EST Estimation),
        %w(KIK Kick Off),
        %w(PLG Planning Game),
        %w(SHO Show and Tell),
        %w(SHP Show and Tell Prep)
    ].each do |eachTuple|
      if find_card_with_number(eachTuple[0]).nil?
          StoryCard.create(estimate: 0,
                         description: '',
                         project_id: self.id,
                         title: eachTuple[1],
                         number: eachTuple[0])
      end
    end
  end

  def common_cards
    unless @common_cards.nil?
      @common_cards = []
      %w(STU EST KIK PLG SHO SHO).each do |eachCardNumber|
        @common_cards.push(find_card_with_number(eachCardNumber))
      end
    end
    return @common_cards
  end

  def find_card_with_number aString
    story_card_find_by = StoryCard.find_by(project_id: self.id, number: aString)
    return story_card_find_by
  end

end