# frozen_string_literal: true

module Game
  class Board
    include Dry::Equalizer(:cells)

    CELLS_PER_ROW = 8

    attr_reader :cells
    attr_accessor :weight

    def initialize(data = {})
      data = data.with_indifferent_access

      @weight = data[:weight] || 1
      cells   = data[:cells] || {}

      @cells = 1.upto(CELLS_PER_ROW).flat_map do |row_number|
        ('A'..'H').map.with_index do |column_char, column_index|
          draught_data = cells[column_char + row_number.to_s]
          draught      =
            if draught_data
              Draught.new id: draught_data['id'], color: draught_data['c'], king: draught_data['k']
            end
          Cell.new(column:   column_char,
                   row:      row_number,
                   draught:  draught)
        end
      end.freeze
    end

    # def populate!
    #   @cells = self.class.from_s(<<~BOARD).cells
    #     . ● . ● . ● . ●
    #     ● . ● . ● . ● .
    #     . ● . ● . ● . ●
    #     . . . . . . . .
    #     . . . . . . . .
    #     ○ . ○ . ○ . ○ .
    #     . ○ . ○ . ○ . ○
    #     ○ . ○ . ○ . ○ .
    #   BOARD
    #   self
    # end

    # @param args [Array] column name or cell index, row number or nil
    # @return [Game::Board::Cell]
    # @example
    #   cell_at('A4')
    #   cell_at('A', 4)
    def cell_at(*args)
      cells[self.class.cell_index(*args)]
    end

    def rows
      cells.each_slice(CELLS_PER_ROW).to_a
    end

    def playable_cells
      cells.select(&:playable)
    end

    def occupied_cells
      playable_cells.select(&:occupied?)
    end

    # @return [Array<Game::Board::Draught>]
    def draughts
      cells.map(&:draught).compact
    end

    # Returns an array of cells lying on the same diagonal as the specified two
    # @return [Array<Game::Board::Cell>]
    def diagonal_through_cells(cell1, cell2)
      raise ArgumentError unless cell1.same_diagonal?(cell2)
      cells.select { |c| c.same_diagonal?(cell1) && c.same_diagonal?(cell2) }
    end

    # @return [Array<Game::Board::Cell>]
    def cells_between(cell1, cell2)
      raise ArgumentError unless cell1.same_diagonal?(cell2)
      cells.select { |c| c.between?(cell1, cell2) }
    end

    def update(update_params)
      new_board = dup
      new_board.update! update_params
    end

    def as_json(*)
      {
        cells:  cells.reject(&:empty?).map do |cell|
          [cell.name, cell.draught.as_json]
        end.to_h,
        weight: weight,
      }
    end

    def to_s
      StringExport.new(self).to_string
    end

    class << self
      # @return [Game::Board]
      def from_s(string)
        ::Game::Board::StringImport.new(string).import
      end

      # @param column [String] column name or cell index
      # @param row [Integer, nil] row number or nil
      # @return [Integer] internal using cell index in cells array
      # @example
      #   cell_index('A4')
      #   cell_index('A', 4)
      def cell_index(column, row = nil)
        unless row.present?
          column, row = column.chars
          row         = row.to_i
        end
        CELLS_PER_ROW * (row - 1) + (column.ord - 'A'.ord)
      end

      def populated
        from_s(<<~BOARD)
          . ● . ● . ● . ●
          ● . ● . ● . ● .
          . ● . ● . ● . ●
          . . . . . . . .
          . . . . . . . .
          ○ . ○ . ○ . ○ .
          . ○ . ○ . ○ . ○
          ○ . ○ . ○ . ○ .
        BOARD
      end
    end

    protected

      def update!(update_params)
        @cells = cells.dup
        update_params.each do |cell_name, draught|
          cells[self.class.cell_index(cell_name)] = cell_at(cell_name).update(draught: draught)
        end
        @cells.freeze
        self
      end
  end
end
