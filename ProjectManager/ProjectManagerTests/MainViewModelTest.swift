//
//  MainViewModelTest.swift
//  ProjectManagerTests
//
//  Created by Kyo on 2023/01/18.
//

import XCTest
@testable import ProjectManager

final class MainViewModelTest: XCTestCase {
    var sut: MainViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_append_TodoData() {
        // given : Data 추가
        let data = TestData.data1
        sut.updateData(data: data)

        // when : todo Data의 0번째 인덱스를 선택했다고 가정
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: .zero)

        let compareData = sut.fetchSeletedData()

        // then : TodoData 추가 확인
        XCTAssertEqual(data, compareData)
    }

    func test_update_TodoData() {
        // given : Data 추가
        let data = TestData.data1
        sut.updateData(data: data)

        // when : todo Data의 첫번째 데이터를 변경
        let updateData = TestData.data2
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: .zero)
        sut.updateData(data: updateData)

        // 변경된 데이터 지정
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: .zero)
        let compareData = sut.fetchSeletedData()

        // then : 데이터 확인
        XCTAssertEqual(updateData, compareData)
    }

    func test_delete_doingData() {
        // given : Data 추가
        let data1 = TestData.data1
        sut.updateData(data: data1)
        let data2 = TestData.data2
        sut.updateData(data: data2)

        // when : todo Data의 data2 데이터를 삭제
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: 1)

        sut.deleteData()

        // then : 삭제된 데이터시 nil 반환
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: 1)

        XCTAssertNil(sut.fetchSeletedData())
    }

    func test_fetch_data_Index가_초과된_경우() {
        // given : Data 추가
        let data1 = TestData.data1
        sut.updateData(data: data1)
        let data2 = TestData.data2
        sut.updateData(data: data2)

        // when : todo Data의 존재하지 않는 세번째 데이터를 select했다고 가정
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: 3)

        // then : 존재하지 않는 index의 Data에 대해서 nil 반환
        XCTAssertNil(sut.fetchSeletedData())
    }

    func test_1번째_TodoData_Move_To_Done() {
        // given : Data 추가
        let data1 = TestData.data1
        sut.updateData(data: data1)
        let data2 = TestData.data2
        sut.updateData(data: data2)

        // when : todo Data의 첫 번째 데이터를 Done으로 이동
        sut.setupUploadDataProcess(process: .todo)
        sut.setupUploadDataIndex(index: .zero)

        sut.changeProcess(after: .done, index: .zero)

        // then : Done Process의 첫 번째 데이터를 확인
        sut.setupUploadDataProcess(process: .done)
        sut.setupUploadDataIndex(index: .zero)

        let compareData = sut.fetchSeletedData()

        XCTAssertEqual(data1, compareData)
    }
}