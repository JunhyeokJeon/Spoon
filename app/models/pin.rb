class Pin < ApplicationRecord
  acts_as_votable
  belongs_to :user

  has_attached_file :image, styles: { medium: "300x300>", big: "900x900>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
