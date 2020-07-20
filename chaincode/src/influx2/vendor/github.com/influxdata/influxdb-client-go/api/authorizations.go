// Copyright 2020 InfluxData, Inc. All rights reserved.
// Use of this source code is governed by MIT
// license that can be found in the LICENSE file.

package api

import (
	"context"
	"github.com/influxdata/influxdb-client-go/domain"
)

// AuthorizationsApi provides methods for organizing Authorization in a InfluxDB server
type AuthorizationsApi interface {
	// GetAuthorizations returns all authorizations
	GetAuthorizations(ctx context.Context) (*[]domain.Authorization, error)
	// FindAuthorizationsByUserName returns all authorizations for given userName
	FindAuthorizationsByUserName(ctx context.Context, userName string) (*[]domain.Authorization, error)
	// FindAuthorizationsByUserId returns all authorizations for given userID
	FindAuthorizationsByUserId(ctx context.Context, userId string) (*[]domain.Authorization, error)
	// FindAuthorizationsByOrgName returns all authorizations for given organization name
	FindAuthorizationsByOrgName(ctx context.Context, orgName string) (*[]domain.Authorization, error)
	// FindAuthorizationsByUserId returns all authorizations for given organization id
	FindAuthorizationsByOrgId(ctx context.Context, orgId string) (*[]domain.Authorization, error)
	// CreateAuthorization creates new authorization
	CreateAuthorization(ctx context.Context, authorization *domain.Authorization) (*domain.Authorization, error)
	// CreateAuthorizationWithOrgId creates new authorization with given permissions scoped to given orgId
	CreateAuthorizationWithOrgId(ctx context.Context, orgId string, permissions []domain.Permission) (*domain.Authorization, error)
	// UpdateAuthorizationStatus updates status of authorization with authId
	UpdateAuthorizationStatus(ctx context.Context, authId string, status domain.AuthorizationUpdateRequestStatus) (*domain.Authorization, error)
	// DeleteAuthorization deletes authorization with authId
	DeleteAuthorization(ctx context.Context, authId string) error
}

type authorizationsApiImpl struct {
	apiClient *domain.ClientWithResponses
}

func NewAuthorizationApi(apiClient *domain.ClientWithResponses) AuthorizationsApi {
	return &authorizationsApiImpl{
		apiClient: apiClient,
	}
}

func (a *authorizationsApiImpl) GetAuthorizations(ctx context.Context) (*[]domain.Authorization, error) {
	authQuery := &domain.GetAuthorizationsParams{}
	auths, err := a.listAuthorizations(ctx, authQuery)
	if err != nil {
		return nil, err
	}
	return auths.Authorizations, nil
}

func (a *authorizationsApiImpl) FindAuthorizationsByUserName(ctx context.Context, userName string) (*[]domain.Authorization, error) {
	authQuery := &domain.GetAuthorizationsParams{User: &userName}
	auths, err := a.listAuthorizations(ctx, authQuery)
	if err != nil {
		return nil, err
	}
	return auths.Authorizations, nil
}

func (a *authorizationsApiImpl) FindAuthorizationsByUserId(ctx context.Context, userId string) (*[]domain.Authorization, error) {
	authQuery := &domain.GetAuthorizationsParams{UserID: &userId}
	auths, err := a.listAuthorizations(ctx, authQuery)
	if err != nil {
		return nil, err
	}
	return auths.Authorizations, nil
}

func (a *authorizationsApiImpl) FindAuthorizationsByOrgName(ctx context.Context, orgName string) (*[]domain.Authorization, error) {
	authQuery := &domain.GetAuthorizationsParams{Org: &orgName}
	auths, err := a.listAuthorizations(ctx, authQuery)
	if err != nil {
		return nil, err
	}
	return auths.Authorizations, nil
}

func (a *authorizationsApiImpl) FindAuthorizationsByOrgId(ctx context.Context, orgId string) (*[]domain.Authorization, error) {
	authQuery := &domain.GetAuthorizationsParams{OrgID: &orgId}
	auths, err := a.listAuthorizations(ctx, authQuery)
	if err != nil {
		return nil, err
	}
	return auths.Authorizations, nil
}

func (a *authorizationsApiImpl) listAuthorizations(ctx context.Context, query *domain.GetAuthorizationsParams) (*domain.Authorizations, error) {
	if query == nil {
		query = &domain.GetAuthorizationsParams{}
	}
	response, err := a.apiClient.GetAuthorizationsWithResponse(ctx, query)
	if err != nil {
		return nil, err
	}
	if response.JSONDefault != nil {
		return nil, domain.DomainErrorToError(response.JSONDefault, response.StatusCode())
	}
	return response.JSON200, nil
}

func (a *authorizationsApiImpl) CreateAuthorization(ctx context.Context, authorization *domain.Authorization) (*domain.Authorization, error) {
	params := &domain.PostAuthorizationsParams{}
	response, err := a.apiClient.PostAuthorizationsWithResponse(ctx, params, domain.PostAuthorizationsJSONRequestBody(*authorization))
	if err != nil {
		return nil, err
	}
	if response.JSONDefault != nil {
		return nil, domain.DomainErrorToError(response.JSONDefault, response.StatusCode())
	}
	if response.JSON400 != nil {
		return nil, domain.DomainErrorToError(response.JSON400, response.StatusCode())
	}
	return response.JSON201, nil
}

func (a *authorizationsApiImpl) CreateAuthorizationWithOrgId(ctx context.Context, orgId string, permissions []domain.Permission) (*domain.Authorization, error) {
	status := domain.AuthorizationUpdateRequestStatusActive
	auth := &domain.Authorization{
		AuthorizationUpdateRequest: domain.AuthorizationUpdateRequest{Status: &status},
		OrgID:                      &orgId,
		Permissions:                &permissions,
	}
	return a.CreateAuthorization(ctx, auth)
}

func (a *authorizationsApiImpl) UpdateAuthorizationStatus(ctx context.Context, authId string, status domain.AuthorizationUpdateRequestStatus) (*domain.Authorization, error) {
	params := &domain.PatchAuthorizationsIDParams{}
	body := &domain.PatchAuthorizationsIDJSONRequestBody{Status: &status}
	response, err := a.apiClient.PatchAuthorizationsIDWithResponse(ctx, authId, params, *body)
	if err != nil {
		return nil, err
	}
	if response.JSONDefault != nil {
		return nil, domain.DomainErrorToError(response.JSONDefault, response.StatusCode())
	}
	return response.JSON200, nil
}

func (a *authorizationsApiImpl) DeleteAuthorization(ctx context.Context, authId string) error {
	params := &domain.DeleteAuthorizationsIDParams{}
	response, err := a.apiClient.DeleteAuthorizationsIDWithResponse(ctx, authId, params)
	if err != nil {
		return err
	}
	if response.JSONDefault != nil {
		return domain.DomainErrorToError(response.JSONDefault, response.StatusCode())
	}
	return nil
}
