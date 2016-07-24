class CsrUpload
  include ActiveModel::Model, ActiveRecord::AttributeAssignment

    attr_accessor :csr, :not_before, :not_after

end
