class Document < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping _source: { excludes: ['attachment'] } do
    indexes :id, type: 'integer'
    indexes :title
    indexes :attachment, type: 'attachment'
  end

  mount_uploader :document_attachment, DocumentAttachmentUploader

  def attachment
    return if document_attachment.nil? || document_attachment.file.nil?
    path_to_attachment = document_attachment.file.file
    Base64.encode64(open(path_to_attachment){ |file| file.read })
  end

  def to_indexed_json
    to_json(methods: [:attachment])
  end
end
