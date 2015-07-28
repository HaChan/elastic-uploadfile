class Document < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mount_uploader :document_attachment, DocumentAttachmentUploader

  mapping _source: {excludes: ['attachment']} do
    indexes :id, type: 'integer'
    indexes :title, type: 'string'
    indexes :attachment, type: 'attachment', analyzer: 'english', index_options: 'offsets'
  end

  def attachment
    return if document_attachment.nil? || document_attachment.file.nil?
    path_to_attachment = document_attachment.file.file
    Base64.encode64(open(path_to_attachment){ |file| file.read })
  end

  def as_indexed_json(options={})
    as_json methods: [:attachment]
  end
end
