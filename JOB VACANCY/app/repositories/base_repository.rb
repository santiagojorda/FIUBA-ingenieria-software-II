class BaseRepository
  def save(a_record)
    if find_dataset_by_id(a_record.id).first
      update(a_record).positive?
    else
      !insert(a_record).id.nil?
    end
  end

  def destroy(a_record)
    find_dataset_by_id(a_record.id).delete.positive?
  end
  alias delete destroy

  def delete_all
    dataset.delete
  end

  def all
    load_collection dataset
  end

  def find(id)
    load_object dataset.first!(pk_column => id)
  end

  def first
    load_object dataset.first
  end

  class << self
    attr_accessor :table_name, :model_class
  end

  protected

  def dataset
    DB[self.class.table_name]
  end

  def load_collection(rows)
    rows.map { |a_record| load_object(a_record) }
  end

  def update(a_record)
    if a_record.valid?
      find_dataset_by_id(a_record.id).update(update_changeset(a_record))
    else
      0
    end
  end

  def insert(a_record)
    if a_record.valid?
      id = dataset.insert(insert_changeset(a_record))
      a_record.id = id
    end
    a_record
  end

  def find_dataset_by_id(id)
    dataset.where(pk_column => id)
  end

  def load_object(a_record)
    Object.const_get(self.class.model_class).new(a_record)
  end

  def insert_changeset(a_record)
    changeset_with_timestamps(a_record).merge(created_on: Date.today)
  end

  def update_changeset(a_record)
    changeset_with_timestamps(a_record).merge(updated_on: Date.today)
  end

  def changeset_with_timestamps(a_record)
    changeset(a_record).merge(created_on: a_record.created_on, updated_on: a_record.updated_on)
  end

  def changeset(_a_record)
    raise 'Subclass must implement'
  end

  def class_name
    self.class.model_class
  end

  def pk_column
    Sequel[self.class.table_name][:id]
  end
end
