class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pins,    dependent: :destroy
  has_many :comments

  validates :nickname, uniqueness: {case_sensitive: false}, presence: true, presence: true, length: {maximum: 20}
  validates :email, uniqueness: {case_sensitive: false}, presence: true, presence: true, length: {maximum: 30}

  has_attached_file :image, styles: { medium: "500x500>", big: "900x900>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
