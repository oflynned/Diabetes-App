import xlrd
import json


class Excel:
    @staticmethod
    def __get_working_dir(file_name):
        return "app/datasets/" + file_name

    @staticmethod
    def __retrieve_data_sheets():
        dataset_file_name = "app_sug_2.xlsx"
        dataset_location = Excel.__get_working_dir(dataset_file_name)

        workbook = xlrd.open_workbook(dataset_location)
        raw_data = []

        # let's start off with working with just the first sheet
        for sheet_index in range(1):
            sheet = workbook.sheet_by_index(sheet_index)

            # let's get the heading names first so we know
            # sheet details for later on
            headings = []
            for r in range(1, 2):  # sheet.nrows):
                row_value = sheet.row_values(r)
                for index, item in enumerate(row_value):
                    if item is not '':
                        headings.append(item.strip())

            # iterate along the 0th col per row to get displacement
            # of how many suggestions there are by differencing
            i = 2
            for r in range(2, sheet.nrows):
                row_value = sheet.row_values(r)
                if row_value[0] is not '':
                    print(row_value[0], i)
                i += 1

        return headings

    @staticmethod
    def groom_content():
        epoch_0_30 = 0
        epoch_30_60 = 30
        epoch_60_150 = 60
        epoch_gr_150 = 150

        return Excel.__retrieve_data_sheets()
