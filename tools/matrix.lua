-- This library provides helper functions for working with 2D matrices.
-- 
-- Author: end draconis
-- SPDX-License-Identifier: CC-BY-4.0

--- Adds two 2D matrices together.
-- @param left 2D matrix. Width must be equal to the height of the right matrix.
-- @param right 2D matrix. Width must be equal to the height of the left matrix.
-- @return 2D matrix the sum of the two matrices
-- @raise 'Matrix sizes do not match'
local function add(left, right)
    if #left ~= #right or #left[1] ~= #right[1] then
        error("Matrix sizes do not match")
    end
    local temp = {}
    for i = 1, #left do
        temp[i] = {}
        for j = 1, #left[1] do
            temp[i][j] = left[i][j] + right[i][j]
        end
    end
    return temp
end

--- Calculates the transpose of a 2D matrix.
-- @param matrix 2D matrix.
-- @return 2D matrix, the transpose of the original matrix.
local function transpose(matrix)
    local temp = {}
    for i = 1, #matrix do
        for j = 1, #matrix[1] do
            if temp[j] == nil then temp[j] = {} end
            temp[j][i] = matrix[i][j]
        end
    end
    return temp
end

--- Multiplies a matrix with another matrix or a scalar.
-- @param left 2D matrix or scalar. For a matrix, width must be equal to the height of the right matrix.
-- @param right 2D matrix. Width must be equal to the height of the left matrix.
-- @return 2D matrix the product of the two matrices or the matrix and the scalar.
-- @raise 'Matrix sizes do not match'
local function multiply(left, right)
    if type(left) == "number" then
        return multiplyScalar(left, right)
    else
        return multiplyMatrices(left, right)
    end
end

--- Multiplies two 2D matrices together.
-- @param left 2D matrix. Width must be equal to the height of the right matrix.
-- @param right 2D matrix. Height must be equal to the width of the left matrix.
-- @return 2D matrix the product of the two matrices.
-- @raise 'Matrix sizes do not match'
function multiplyMatrices(left, right)
    if #left[1] ~= #right then
        error("Matrix sizes do not match\nA: " .. #left .. "x" .. #left[1] .. "\nB: " .. #right .. "x" .. #right[1])
    end
    
    local temp = {}
    for i = 1, #left do
        temp[i] = {}
        for j = 1, #right[1] do
            local sum = 0
            for k = 1, #left[1] do
                sum = sum + left[i][k] * right[k][j]
            end
            temp[i][j] = sum
        end
    end
    return temp
end

--- Multiplies a matrix with a scalar.
-- @param num scalar.
-- @param matrix 2D matrix.
-- @return 2D matrix the product of the matrix and the scalar.
function multiplyScalar(num, matrix)
    local temp = {}
    for i = 1, #matrix do
        temp[i] = {}
        for j = 1, #matrix[1] do
            temp[i][j] = num * matrix[i][j]
        end
    end
    return temp
end

return {add = add, transpose = transpose, multiply = multiply}