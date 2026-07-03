//
//  UserInfoMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

extension UserInfo {
    init(dto: UserInfoDTO) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullname
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.businessId = dto.business_id
        self.businessOwnerId = dto.business_owner_id
        self.businessTypeId = dto.business_type_id
        self.hasEmployees = dto.has_employees
        self.isValidated = dto.is_validated
        self.registrationStep = RegistrationStepEnum.fromKey(dto.registration_step)
    }
}
