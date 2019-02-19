class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  scope :orders, -> { order created_at: :desc }
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: Settings.micropost_validates.max_lenght_content }
  validate :picture_size

  private

  def picture_size
    return errors.add :picture, t(".error") if picture.size > Settings.picture_size.megabytes
  end
end
