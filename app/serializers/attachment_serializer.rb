class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file

  def file
    object.file.url
  end
end
