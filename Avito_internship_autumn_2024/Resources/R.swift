//
//  R.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

enum R {
    enum Colors {
        static let backgroungColor   = UIColor(hexString: "#F8F4FF")
        static let textColor =  UIColor(hexString: "#755A57")
        static let separator = UIColor(hexString: "#A0A0A0")
        static let buttonColor = UIColor(hexString: "#BC987E")
        static let filterButton = UIColor(hexString: "#CFCFCF")
        static let black = UIColor.black
    }
    
    enum Strings {
        static let description = "Описание"
        static let OK = "ОК"
        static let errorTitle = "Что-то пошло не так"
        static let successfully = "Успешно"
        static let imageSave = "Изображение сохранено в галерею."
        static let imageSaveError = "Изображение не загружено!"
        static let placeholder = "Посмотреть на звезды"
        static let results = "Результаты:"
        static let ribbon = "Лента"
        static let title = "Avinterest"
        static let messageAlert = "Что у вас здесь происходит"
        static let newsButton = "Сначала новые"
        static let popularButton = "Сначала популярные"
    }
    
    enum Image {
        static let heart = UIImage(systemName: "heart")
        static let chevronLeft = UIImage(systemName: "chevron.left")
        static let chevronRight = UIImage(systemName: "chevron.right")
        static let squareAndArrowUp = UIImage(systemName: "square.and.arrow.up")
        static let squareAndArrowDown = UIImage(systemName: "square.and.arrow.down")
        static let filter = UIImage(systemName: "line.horizontal.3.decrease.circle")
        static let calendar = UIImage(systemName: "calendar")
        static let checkmark = UIImage(systemName: "checkmark")
        static let clock = UIImage(systemName: "clock.arrow.circlepath")
    }
    
    enum Constants {
        static let historyItemKey = "HistoryItemKey"
        static let historyItemCellIdentifier = "HistoryItemCell"
        static let sortedBy = "relevant"
    }

    enum Fonts {
        static let pouf = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let subheadFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let textFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let dataFont = UIFont.systemFont(ofSize: 12, weight: .light)
    }
    
    enum StringsMessage {
        static let noDescription = "Описание отсутствует"
        static let noBio = "Биография отсутствует"
        static let noData = "Неизвестная дата"
    }
    
}
